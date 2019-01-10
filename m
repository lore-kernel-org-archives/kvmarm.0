From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool v2 07/13] net/uip: Add exit function
Date: Thu, 10 Jan 2019 14:12:44 +0000
Message-ID: <1547129570-14351-8-git-send-email-julien.thierry@arm.com>
References: <1547129570-14351-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 857754A473
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:13:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LytHxEScUkZI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jan 2019 09:13:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D089D4A487
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:13:06 -0500 (EST)
In-Reply-To: <1547129570-14351-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: will.deacon@arm.com, kraxel@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

When resetting the virtio-net queues, the UIP state needs to be reset as
well. Stop all threads (one per TCP stream and UDP connection) and free
memory.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 include/kvm/uip.h |  6 ++++++
 net/uip/core.c    | 17 +++++++++++++++++
 net/uip/dhcp.c    |  6 ++++++
 net/uip/tcp.c     | 54 ++++++++++++++++++++++++++++++++++++++++++++----------
 net/uip/udp.c     | 41 +++++++++++++++++++++++++++++++++++------
 5 files changed, 108 insertions(+), 16 deletions(-)

diff --git a/include/kvm/uip.h b/include/kvm/uip.h
index a9a8d85..efa508a 100644
--- a/include/kvm/uip.h
+++ b/include/kvm/uip.h
@@ -196,6 +196,7 @@ struct uip_info {
 	struct list_head buf_head;
 	struct mutex buf_lock;
 	pthread_t udp_thread;
+	u8 *udp_buf;
 	int udp_epollfd;
 	int buf_free_nr;
 	int buf_used_nr;
@@ -249,6 +250,7 @@ struct uip_tcp_socket {
 	int read_done;
 	u32 dip, sip;
 	u8 *payload;
+	u8 *buf;
 	int fd;
 };
 
@@ -336,6 +338,9 @@ int uip_tx(struct iovec *iov, u16 out, struct uip_info *info);
 int uip_rx(struct iovec *iov, u16 in, struct uip_info *info);
 void uip_static_init(struct uip_info *info);
 int uip_init(struct uip_info *info);
+void uip_exit(struct uip_info *info);
+void uip_tcp_exit(struct uip_info *info);
+void uip_udp_exit(struct uip_info *info);
 
 int uip_tx_do_ipv4_udp_dhcp(struct uip_tx_arg *arg);
 int uip_tx_do_ipv4_icmp(struct uip_tx_arg *arg);
@@ -359,4 +364,5 @@ int uip_udp_make_pkg(struct uip_info *info, struct uip_udp_socket *sk, struct ui
 bool uip_udp_is_dhcp(struct uip_udp *udp);
 
 int uip_dhcp_get_dns(struct uip_info *info);
+void uip_dhcp_exit(struct uip_info *info);
 #endif /* KVM__UIP_H */
diff --git a/net/uip/core.c b/net/uip/core.c
index e860f3a..977b9b0 100644
--- a/net/uip/core.c
+++ b/net/uip/core.c
@@ -154,3 +154,20 @@ int uip_init(struct uip_info *info)
 
 	return 0;
 }
+
+void uip_exit(struct uip_info *info)
+{
+	struct uip_buf *buf, *next;
+
+	uip_udp_exit(info);
+	uip_tcp_exit(info);
+	uip_dhcp_exit(info);
+
+	list_for_each_entry_safe(buf, next, &info->buf_head, list) {
+		free(buf->vnet);
+		free(buf->eth);
+		list_del(&buf->list);
+		free(buf);
+	}
+	uip_static_init(info);
+}
diff --git a/net/uip/dhcp.c b/net/uip/dhcp.c
index b17d352..8f01300 100644
--- a/net/uip/dhcp.c
+++ b/net/uip/dhcp.c
@@ -200,3 +200,9 @@ int uip_tx_do_ipv4_udp_dhcp(struct uip_tx_arg *arg)
 
 	return 0;
 }
+
+void uip_dhcp_exit(struct uip_info *info)
+{
+	free(info->domain_name);
+	info->domain_name = NULL;
+}
diff --git a/net/uip/tcp.c b/net/uip/tcp.c
index 3c30ade..8e0ad52 100644
--- a/net/uip/tcp.c
+++ b/net/uip/tcp.c
@@ -18,6 +18,7 @@ static int uip_tcp_socket_close(struct uip_tcp_socket *sk, int how)
 		list_del(&sk->list);
 		mutex_unlock(sk->lock);
 
+		free(sk->buf);
 		free(sk);
 	}
 
@@ -94,6 +95,24 @@ static struct uip_tcp_socket *uip_tcp_socket_alloc(struct uip_tx_arg *arg, u32 s
 	return sk;
 }
 
+/* Caller holds the sk lock */
+static void uip_tcp_socket_free(struct uip_tcp_socket *sk)
+{
+	/*
+	 * Here we assume that the virtqueues are already inactive so we don't
+	 * race with uip_tx_do_ipv4_tcp. We are racing with
+	 * uip_tcp_socket_thread though, but holding the sk lock ensures that it
+	 * cannot free data concurrently.
+	 */
+	if (sk->thread) {
+		pthread_cancel(sk->thread);
+		pthread_join(sk->thread, NULL);
+	}
+
+	sk->write_done = sk->read_done = 1;
+	uip_tcp_socket_close(sk, SHUT_RDWR);
+}
+
 static int uip_tcp_payload_send(struct uip_tcp_socket *sk, u8 flag, u16 payload_len)
 {
 	struct uip_info *info;
@@ -175,20 +194,16 @@ static void *uip_tcp_socket_thread(void *p)
 {
 	struct uip_tcp_socket *sk;
 	int len, left, ret;
-	u8 *payload, *pos;
+	u8 *pos;
 
 	kvm__set_thread_name("uip-tcp");
 
 	sk = p;
 
-	payload = malloc(UIP_MAX_TCP_PAYLOAD);
-	if (!payload)
-		goto out;
-
 	while (1) {
-		pos = payload;
+		pos = sk->buf;
 
-		ret = read(sk->fd, payload, UIP_MAX_TCP_PAYLOAD);
+		ret = read(sk->fd, sk->buf, UIP_MAX_TCP_PAYLOAD);
 
 		if (ret <= 0 || ret > UIP_MAX_TCP_PAYLOAD)
 			goto out;
@@ -224,7 +239,6 @@ out:
 
 	sk->read_done = 1;
 
-	free(payload);
 	pthread_exit(NULL);
 
 	return NULL;
@@ -232,8 +246,18 @@ out:
 
 static int uip_tcp_socket_receive(struct uip_tcp_socket *sk)
 {
-	if (sk->thread == 0)
-		return pthread_create(&sk->thread, NULL, uip_tcp_socket_thread, (void *)sk);
+	int ret;
+
+	if (sk->thread == 0) {
+		sk->buf = malloc(UIP_MAX_TCP_PAYLOAD);
+		if (!sk->buf)
+			return -ENOMEM;
+		ret = pthread_create(&sk->thread, NULL, uip_tcp_socket_thread,
+				     (void *)sk);
+		if (ret)
+			free(sk->buf);
+		return ret;
+	}
 
 	return 0;
 }
@@ -346,3 +370,13 @@ int uip_tx_do_ipv4_tcp(struct uip_tx_arg *arg)
 out:
 	return 0;
 }
+
+void uip_tcp_exit(struct uip_info *info)
+{
+	struct uip_tcp_socket *sk, *next;
+
+	mutex_lock(&info->tcp_socket_lock);
+	list_for_each_entry_safe(sk, next, &info->tcp_socket_head, list)
+		uip_tcp_socket_free(sk);
+	mutex_unlock(&info->tcp_socket_lock);
+}
diff --git a/net/uip/udp.c b/net/uip/udp.c
index dd288c5..d2580d0 100644
--- a/net/uip/udp.c
+++ b/net/uip/udp.c
@@ -164,10 +164,7 @@ static void *uip_udp_socket_thread(void *p)
 	kvm__set_thread_name("uip-udp");
 
 	info = p;
-
-	do {
-		payload = malloc(UIP_MAX_UDP_PAYLOAD);
-	} while (!payload);
+	payload = info->udp_buf;
 
 	while (1) {
 		nfds = epoll_wait(info->udp_epollfd, events, UIP_UDP_MAX_EVENTS, -1);
@@ -196,7 +193,11 @@ static void *uip_udp_socket_thread(void *p)
 		}
 	}
 
-	free(payload);
+	mutex_lock(&info->udp_socket_lock);
+	free(info->udp_buf);
+	info->udp_buf = NULL;
+	mutex_unlock(&info->udp_socket_lock);
+
 	pthread_exit(NULL);
 	return NULL;
 }
@@ -232,8 +233,36 @@ int uip_tx_do_ipv4_udp(struct uip_tx_arg *arg)
 	if (ret)
 		return -1;
 
-	if (!info->udp_thread)
+	if (!info->udp_thread) {
+		info->udp_buf = malloc(UIP_MAX_UDP_PAYLOAD);
+		if (!info->udp_buf)
+			return -1;
+
 		pthread_create(&info->udp_thread, NULL, uip_udp_socket_thread, (void *)info);
+	}
 
 	return 0;
 }
+
+void uip_udp_exit(struct uip_info *info)
+{
+	struct uip_udp_socket *sk, *next;
+
+	mutex_lock(&info->udp_socket_lock);
+	if (info->udp_thread) {
+		pthread_cancel(info->udp_thread);
+		pthread_join(info->udp_thread, NULL);
+		info->udp_thread = 0;
+		free(info->udp_buf);
+	}
+	if (info->udp_epollfd > 0) {
+		close(info->udp_epollfd);
+		info->udp_epollfd = 0;
+	}
+
+	list_for_each_entry_safe(sk, next, &info->udp_socket_head, list) {
+		close(sk->fd);
+		free(sk);
+	}
+	mutex_unlock(&info->udp_socket_lock);
+}
-- 
1.9.1
