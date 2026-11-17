Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931839;
	b=IdNvqvBan3puxA4s1aFXo820jwETuJ8OyMIHcAU8PedX9Mr60KqYARRa3ft1+iCE+a05
	 wVlDT/lA8j8O9Q0BY02tGc+kEmfMkWhW+u6HWowlJgaPwqyd9QgAvIVd/ubbTyRw30tFd
	 TuvqQiuJzCPfLO7Eq4RZXsi2it0zgAvkP3QBjePP9fblBUp8Snkz5RXNlJR6sarvAGjeW
	 bjhU4SIc2ODQXyEMgL1+hPlz5/0p327CJ1V0985pQtmxx+0g2VONrPITIKfHbHKzeEJ7I
	 9PHRJ3SDeoE40SRBEa3ViUrgFpNSlEfOvi4EEE3zdDtj+M9nSeJFvKkjK9lqscgjVpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931839;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+Lpr9cKkxrLx73QOmdMkKVTocviV8TbIfP0oOAlS8dA=;
	b=CMMgA7TZYG6BnEU4JSNM8zu7vJ2byxtWRHmj+0tojRKqukPa+gUMSjzZSDIw9O1u2krB
	 UhRSJ8O2gSVsVju6f06zhLT80BCdda65MyE+uz7hD/TAyvPcPZk/oGE+uV6Sd5Le6cyfR
	 YpSwr2WKSm0gUJ89JVtaqGCghjh+vjH4LxpNJFQLlVrwEHBf5k2jFvmfv3mJF2gOSjkHg
	 k3pzNfC+9TAI+nKEURreEvHQJRGL+B9o78tYEUpbpLAMxybbvvMEcetBhKbz7Nka/wIIH
	 fi+GRibW/oIfEsKwLfbwIUYU8MDgXF26PaE4qMRJD84mtJkmWNOOzvZbfsB8bL78x2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=VEv3pcJN;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B14606A330
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 16:10:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89B14606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=VEv3pcJN
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F191B1A00;
	Tue, 17 Nov 2026 08:10:34 -0800 (PST)
Received: from gentoo-vm (kajpuc01-mac-mini.manchester.arm.com [10.33.9.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 11B5D3F632;
	Tue, 17 Nov 2026 08:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794931837; bh=Unmy4knUS3OUA8p8EnyBnKyXh5CQud68fonNVN+bzJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEv3pcJNHMw9B8IwTAgApk/WzCeqO444iBo8wrheCJuHGi/zeEhYeZNDhz5ZFHbPs
	 RlOR0VM1XvQvNY6oeNzYGg1bE0Bbasm2Cz44OUD/4lg7iGgx2cjzITCxyLrZRPilwj
	 HPYN/kzbGyAVju57nzQ62vZBARknBqYezI9mfDSE=
From: Kajetan Puchalski <kajetan.puchalski@arm.com>
To: kvm@vger.kernel.org
Cc: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	kvmarm@lists.linux.dev,
	Kajetan Puchalski <kajetan.puchalski@arm.com>
Subject: [PATCH kvmtool 2/2] net: Use the host as a DNS proxy on loopback DNS
Date: Tue, 17 Nov 2026 16:10:19 +0000
Message-ID: <20261117161019.142337-2-kajetan.puchalski@arm.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117161019.142337-1-kajetan.puchalski@arm.com>
References: <20261117161019.142337-1-kajetan.puchalski@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

systemd-resolved populates /etc/resolv.conf with a loopback address.
Using it as-is results in broken guest DNS due to kvmtool not
distinguishing between a loopback and a real DNS server.
When uip_dhcp_get_dns encounters a loopback address, mark it as
requiring a DNS proxy and use the host address as this proxy, forwarding
traffic to it over UDP and TCP to keep guest DNS working out of the box.

Signed-off-by: Kajetan Puchalski <kajetan.puchalski@arm.com>
---
 include/kvm/uip.h |  9 +++++++++
 net/uip/dhcp.c    | 25 +++++++++++++++++++++++--
 net/uip/tcp.c     |  4 +++-
 net/uip/udp.c     |  3 +++
 4 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/include/kvm/uip.h b/include/kvm/uip.h
index efa508a..f226c6b 100644
--- a/include/kvm/uip.h
+++ b/include/kvm/uip.h
@@ -30,6 +30,8 @@
 #define UIP_TCP_FLAG_ACK	16
 #define UIP_TCP_FLAG_URG	32
 
+#define UIP_DNS_PORT		53
+
 #define UIP_BOOTP_VENDOR_SPECIFIC_LEN	64
 #define UIP_BOOTP_MAX_PAYLOAD_LEN	300
 #define UIP_DHCP_VENDOR_SPECIFIC_LEN	312
@@ -204,6 +206,7 @@ struct uip_info {
 	u32 guest_netmask;
 	u32 host_ip;
 	u32 dns_ip[UIP_DHCP_MAX_DNS_SERVER_NR];
+	u32 dns_proxy_ip;
 	char *domain_name;
 	u32 buf_nr;
 	u32 vnet_hdr_len;
@@ -334,6 +337,12 @@ static inline u16 uip_eth_hdrlen(struct uip_eth *eth)
 	return sizeof(*eth);
 }
 
+static inline bool uip_is_dns_proxy(const struct uip_info *info, u32 dip, u16 dport)
+{
+	return info->dns_proxy_ip && dip == htonl(info->host_ip) &&
+		   dport == htons(UIP_DNS_PORT);
+}
+
 int uip_tx(struct iovec *iov, u16 out, struct uip_info *info);
 int uip_rx(struct iovec *iov, u16 in, struct uip_info *info);
 void uip_static_init(struct uip_info *info);
diff --git a/net/uip/dhcp.c b/net/uip/dhcp.c
index a949a6b..0ae0ca8 100644
--- a/net/uip/dhcp.c
+++ b/net/uip/dhcp.c
@@ -57,9 +57,28 @@ int uip_dhcp_get_dns(struct uip_info *info)
 		else if (strncmp("nameserver", key, 10) == 0) {
 			if (!inet_aton(val, &addr))
 				continue;
+
+			if (n >= UIP_DHCP_MAX_DNS_SERVER_NR)
+				continue;
+
 			ip = ntohl(addr.s_addr);
-			if (n < UIP_DHCP_MAX_DNS_SERVER_NR)
-				info->dns_ip[n++] = ip;
+			/*
+			 * systemd-resolved on modern systems puts a loopback
+			 * address in /etc/resolv.conf. Applying the loopback to
+			 * the guest will result in broken guest DNS instead of
+			 * the intended behaviour of using the host's DNS.
+			 * Use the host as a DNS proxy instead.
+			 */
+			if ((ip >> 24) == IN_LOOPBACKNET) {
+				/* Keep the first loopback nameserver */
+				if (info->dns_proxy_ip)
+					continue;
+
+				info->dns_proxy_ip = ip;
+				ip = info->host_ip;
+			}
+
+			info->dns_ip[n++] = ip;
 			ret = 0;
 		}
 	}
@@ -208,4 +227,6 @@ void uip_dhcp_exit(struct uip_info *info)
 {
 	free(info->domain_name);
 	info->domain_name = NULL;
+	memset(info->dns_ip, 0, sizeof(info->dns_ip));
+	info->dns_proxy_ip = 0;
 }
diff --git a/net/uip/tcp.c b/net/uip/tcp.c
index 42e6e99..2a87d68 100644
--- a/net/uip/tcp.c
+++ b/net/uip/tcp.c
@@ -83,7 +83,9 @@ static struct uip_tcp_socket *uip_tcp_socket_alloc(struct uip_tx_arg *arg, u32 s
 
 	pthread_cond_init(&sk->cond, NULL);
 
-	if (ntohl(dip) == arg->info->host_ip)
+	if (uip_is_dns_proxy(arg->info, dip, dport))
+		sk->addr.sin_addr.s_addr = htonl(arg->info->dns_proxy_ip);
+	else if (ntohl(dip) == arg->info->host_ip)
 		sk->addr.sin_addr.s_addr = inet_addr("127.0.0.1");
 
 	ret = connect(sk->fd, (struct sockaddr *)&sk->addr, sizeof(sk->addr));
diff --git a/net/uip/udp.c b/net/uip/udp.c
index d2580d0..058c2b7 100644
--- a/net/uip/udp.c
+++ b/net/uip/udp.c
@@ -69,6 +69,9 @@ static struct uip_udp_socket *uip_udp_socket_find(struct uip_tx_arg *arg, u32 si
 	sk->addr.sin_addr.s_addr = dip;
 	sk->addr.sin_port	 = dport;
 
+	if (uip_is_dns_proxy(arg->info, dip, dport))
+		sk->addr.sin_addr.s_addr = htonl(arg->info->dns_proxy_ip);
+
 	sk->sip			 = sip;
 	sk->dip			 = dip;
 	sk->sport		 = sport;
-- 
2.56.1

