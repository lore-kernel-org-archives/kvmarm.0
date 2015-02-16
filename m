From: Jan Kiszka <jan.kiszka@web.de>
Subject: vexpress: Horribly slow MMC emulation on ARM host
Date: Mon, 16 Feb 2015 07:56:22 +0100
Message-ID: <54E19496.6020905@web.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0720951450571824674=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C224E45BF3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Feb 2015 01:51:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wEtnY7aqxpuW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Feb 2015 01:51:09 -0500 (EST)
Received: from mout.web.de (mout.web.de [212.227.15.4])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CE8E45B19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Feb 2015 01:51:09 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel <qemu-devel@nongnu.org>
Cc: kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============0720951450571824674==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="APC6aJCiuOXrhsGN14xXeMvJNqCAOT6Tf"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--APC6aJCiuOXrhsGN14xXeMvJNqCAOT6Tf
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

this basically concludes my problems of getting KVM running on the
Jetson TK1 board with QEMU: all fine now, provided I switch from

  qemu-system-arm -machine vexpress-a15 -sd disk.img ...

to

  qemu-system-arm -machine vexpress-a15 \
    -drive file=3Ddisk.img,if=3Dnone,id=3Ddisk \
    -device virtio-blk-device,drive=3Ddisk ...

This applies to both emulated and KVM accelerated mode. If I run the
same image (and guest kernel) emulated on my x86 box, there is still a
difference between both disk modes, but it's not that excessive. On ARM
the system requires minutes to boot from MMC - if it doesn't run into
timeouts earlier. It's seconds with virtio.

Known problem?

Jan


--APC6aJCiuOXrhsGN14xXeMvJNqCAOT6Tf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlThlJYACgkQitSsb3rl5xSLuACePhCZYcHEaGmSU8Zr21N1P87I
yrYAn3zKM/TM/Z/yf+pENn6uYemvoBRO
=4X+L
-----END PGP SIGNATURE-----

--APC6aJCiuOXrhsGN14xXeMvJNqCAOT6Tf--

--===============0720951450571824674==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0720951450571824674==--
