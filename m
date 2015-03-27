From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] kvmtool: Add minimal support for macvtap
Date: Fri, 27 Mar 2015 13:48:18 +0000
Message-ID: <1427464098-16300-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Pekka Enberg <penberg@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

In order to be useable by kvmtool, a macvtap interface requires
some minimal configuration (basically setting up the offload bits).
This requires skipping some of the low level TUN/TAP setup.

To avoid adding yet another option, we extend the 'tapif' option
to detect the use of a file (such as /dev/tap23).

Assuming you've run the following as root:

	# ip link add link eth0 name kvmtap0 type macvtap mode bridge
	# chgrp kvm /dev/tap$(< /sys/class/net/kvmtap0/ifindex)
	# chmod g+rw /dev/tap$(< /sys/class/net/kvmtap0/ifindex)

it is fairly easy to have a script that does the following:

	#!/bin/sh
	addr=$(< /sys/class/net/kvmtap0/address)
	tap=/dev/tap$(< /sys/class/net/kvmtap0/ifindex)

	kvmtool/lkvm run --console virtio			\
		-k /boot/zImage					\
		-p "console=hvc0 earlyprintk"			\
		-n trans=mmio,mode=tap,tapif=$tap,guest_mac=$addr

and you now have your VM running, directly attached to the network.

This patch also removes the TUNSETNOCSUM ioctl that has declared
obsolete for quite some time now...

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 tools/kvm/virtio/net.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/tools/kvm/virtio/net.c b/tools/kvm/virtio/net.c
index ecdb94e..25b9496 100644
--- a/tools/kvm/virtio/net.c
+++ b/tools/kvm/virtio/net.c
@@ -276,6 +276,23 @@ static void virtio_net_handle_callback(struct kvm *kvm, struct net_dev *ndev, in
 	mutex_unlock(&ndev->io_lock[queue]);
 }
 
+static int virtio_net_request_tap(struct net_dev *ndev, struct ifreq *ifr,
+				  const char *tapname)
+{
+	int ret;
+
+	memset(ifr, 0, sizeof(*ifr));
+	ifr->ifr_flags = IFF_TAP | IFF_NO_PI | IFF_VNET_HDR;
+	if (tapname)
+		strncpy(ifr->ifr_name, tapname, sizeof(ifr->ifr_name));
+
+	ret = ioctl(ndev->tap_fd, TUNSETIFF, &ifr);
+
+	if (ret >= 0)
+		strncpy(ndev->tap_name, ifr->ifr_name, sizeof(ndev->tap_name));
+	return ret;
+}
+
 static bool virtio_net__tap_init(struct net_dev *ndev)
 {
 	int sock = socket(AF_INET, SOCK_STREAM, 0);
@@ -284,6 +301,8 @@ static bool virtio_net__tap_init(struct net_dev *ndev)
 	struct ifreq ifr;
 	const struct virtio_net_params *params = ndev->params;
 	bool skipconf = !!params->tapif;
+	bool macvtap = skipconf && (params->tapif[0] == '/');
+	const char *tap_file = "/dev/net/tun";
 
 	/* Did the user already gave us the FD? */
 	if (params->fd) {
@@ -291,28 +310,21 @@ static bool virtio_net__tap_init(struct net_dev *ndev)
 		return 1;
 	}
 
-	ndev->tap_fd = open("/dev/net/tun", O_RDWR);
+	if (macvtap)
+		tap_file = params->tapif;
+
+	ndev->tap_fd = open(tap_file, O_RDWR);
 	if (ndev->tap_fd < 0) {
-		pr_warning("Unable to open /dev/net/tun");
+		pr_warning("Unable to open %s", tap_file);
 		goto fail;
 	}
 
-	memset(&ifr, 0, sizeof(ifr));
-	ifr.ifr_flags = IFF_TAP | IFF_NO_PI | IFF_VNET_HDR;
-	if (params->tapif)
-		strncpy(ifr.ifr_name, params->tapif, sizeof(ifr.ifr_name));
-	if (ioctl(ndev->tap_fd, TUNSETIFF, &ifr) < 0) {
+	if (!macvtap &&
+	    virtio_net_request_tap(ndev, &ifr, params->tapif) < 0) {
 		pr_warning("Config tap device error. Are you root?");
 		goto fail;
 	}
 
-	strncpy(ndev->tap_name, ifr.ifr_name, sizeof(ndev->tap_name));
-
-	if (ioctl(ndev->tap_fd, TUNSETNOCSUM, 1) < 0) {
-		pr_warning("Config tap device TUNSETNOCSUM error");
-		goto fail;
-	}
-
 	hdr_len = has_virtio_feature(ndev, VIRTIO_NET_F_MRG_RXBUF) ?
 			sizeof(struct virtio_net_hdr_mrg_rxbuf) :
 			sizeof(struct virtio_net_hdr);
-- 
2.1.4

