Return-Path: <SRS0=hKGY=6M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA19C83000
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 13:09:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 44803206A1
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 13:09:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=web.de header.i=@web.de header.b="PSLkuXkh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44803206A1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=web.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF9AF4B286;
	Tue, 28 Apr 2020 09:09:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@web.de
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UqeWAqmx7gy4; Tue, 28 Apr 2020 09:09:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95C654B288;
	Tue, 28 Apr 2020 09:09:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A21F64B1F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 08:39:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BkzwDlVlTNli for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2020 08:39:02 -0400 (EDT)
Received: from mout.web.de (mout.web.de [212.227.15.4])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 63BB14B1F7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 08:39:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
 s=dbaedf251592; t=1588077540;
 bh=uQwbH454f0gvDC4JIzZ39otWeu4LRi8sg9802Ksokko=;
 h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
 b=PSLkuXkhm9wJOYvkT6fPW2rQ9GgYn7OSK4xhbnUiGy5ev/jPwDJVvtgUsXRbvz1ba
 B9Vg/i41u24nbr+Vj56TR+Zq8S7M60z0mmQyxQXSOCjR9l9qfmjFnLPkCUb3OAuUST
 URyyI/SkWx9lGhlAlDfzA9Pe/wuDtdFLCXzW8Tu8=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from luklap ([94.134.180.8]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MRD0p-1jbyjk499z-00UWhH; Tue, 28
 Apr 2020 14:39:00 +0200
Date: Tue, 28 Apr 2020 14:38:50 +0200
From: Lukas Straub <lukasstraub2@web.de>
To: kvmarm@lists.cs.columbia.edu
Subject: Against removing aarch32 kvm host support
Message-ID: <20200428143850.4c8cbd2a@luklap>
MIME-Version: 1.0
X-Provags-ID: V03:K1:5o4ibYrEfygVMB7pNk1k2Y4+srFg4x1KzaRFPI7d7wLoZFcv4vH
 Vsq+OvB/GYg1mAmK3bLY7rgy0eubW1zuLCFwfNVvZq5lNE3sFZFNxGCq9/oovSLH5FvLw4f
 W0+QXQvz5F67Zk9vytmVAGSSc/15VB76Djn3esUhprtqBmn3jL5abGso4cSy6MwnZSHEDR8
 2AZ4MpMIkuAO7pylAB0ng==
X-UI-Out-Filterresults: notjunk:1;V03:K0:+jfAGiK0wF0=:sl66xQYxXjYqZNbOtftMWF
 LLuEF5v/C+v+Atvlp1i9q5y9nCQfzTOXCVsYQywev5yYt9HKoaWnHM7yleuLCL+FjRfcFicK/
 MmT4d25I7bOsgcsScjRLSvlzmr5+m6I5AXw7Ztf4s0JuKkRrQT2xlgQp7I42X5kcoZEaqN3Kp
 pDPljlxSoOc4n32Ul3WJ6M9t3YzwbGdlHxG6/7nhNexjx7hfg8syxXjbH0JPGR67znmchMa9X
 NQFDJIwUYRpoWZFKz594UjmFIAtmBeqaOklnFGoKpqOnuZ/Ks0Y1oUUwNSMuez9NANeiZcQuq
 oIgR5JtW/Hd4CoAg4WTPWfnmhuUE1cMhObuVQsSgUJDmCj++Gh+NGBAhtohUHTJvQ1th1PaCD
 uqKLYrWx7WiM6H6At/WtitOrYE/KqKxP2UXOjRAw/bVUGc8b//OX9c0xS/0vmUN9zW4eKC3Pm
 gV92s+nW1QJqddOJWHIk57CdGdnD68jxNRGQMj3WvpwrCkY12MJ9QK9yocvRMBY1lIq6j8dt+
 V7OqRyctTDyuAsFjFelghXArRKNq4+Yj9lbzdznrYUr5EUpiADzVotr6N6Zu2/uY6qUuicvZ7
 3Q1ocdcA5D6uvLvxxjbrswnsm3WwZtX0gaol2bCFW8weqYFo2rhG+E4jVe5JS8UjQ27QCtzbk
 ECF8nzeBnhTpPTKc3TMRomYWHRS+5vHQpUVPtj8Cm0xO9T2wx7VyLAVwgPQWLFRUN1KuESkns
 qDkmYJblujiVwCLH8uIiPcbODbnMllaGqBZ3UdlLROYEkScnpBud43PonxYCd01cQN9AM2NXA
 6yDs3PWI6Gn1JQiTX8CMQrzEr8Z4ZzLmoyMLk8yh6+BZR3hN6MH5ExpXyPxuFStvgOJZd20wJ
 DVDlxrQw8Gbqs+16FCiszyDVPcYoMPb66PgWteWcFdw7iWLvsZq245fl7VSuBzKq0p/vWvNNY
 TJGhuXCilZ7VEmDv45RZPuPpD41kHErLrftMxoGB78Jj+cAVi/fxtVjz00oSsFABpWIqYcClu
 L+Q8fEEG60LtRKQCBzqbi16ALTgwmTb4Lk2UuVw5dNQ33Aq/utBtDJNo3ktK3QJLmFF2N/lXh
 PgDrt+vfeTXZAtRqPxuLuHoXpb69fLwYMXup9FAxJpO8ZgYuDe4dRWQTyXrMYVQ5HWkykZb7H
 Wma5zkU/gy3vxLnE21L8cHlgdfepQ5XQno7uI4+cu9s6CUFB+wdVVUOOYHtW7O5BV3enOGYhY
 oy1ue9mrZZDs2revY
X-Mailman-Approved-At: Tue, 28 Apr 2020 09:09:50 -0400
Cc: kvm@vger.kernel.org, kernel@pyra-handheld.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2003584969240408755=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============2003584969240408755==
Content-Type: multipart/signed; boundary="Sig_/MktA=Dv1EjHA4CX8vUSTchZ";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/MktA=Dv1EjHA4CX8vUSTchZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello Everyone,
As a preorder of the Pyra handheld, (OMAP5 SoC with 2x cortex-a15 arm cores)
I'm against removing KVM host support for aarch32. I'm probably going to use
this device for more than 5 years and thus the latest lts-kernel is no opti=
on
for me.

Regards,
Lukas Straub

--Sig_/MktA=Dv1EjHA4CX8vUSTchZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAl6oI9oACgkQNasLKJxd
slg/3Q/8CDCjeuUL6fjcGSdcXaIIgwytnr1e6qlfxXgFXw2wiLfZAmyo5zeXdmqq
1TjIzMOdNowwMXTZVKBp5zGXvg5/VKcX/Sp2d/wk7QY8cxfeRwz9jwSywQ1D9aqa
Ipiqcy/HPtzOlzgUrzoXROEFEn9q/7+//b2vNkHnOY+pNA+m4m+PzY3ndY6CcpBO
rH/k0TdTP0jraDGhoh3qcL4+Zsrhfn0DRyH6W8gkF/aiW4FB96uMxyO0OZ+l/uK1
lxzazng8J84wmx4gbnnG+TqUK6gI4S92I7vnjx6qA2h5cPI9JKRJhc0dTZNzKErZ
XtznnB0eJM7BaMsMGritiichC/VXWzj4o95zlTieaymMMmjrK8BxqZ1vgU8NlT5O
3AI5Z5h0VFre9LQioHmMaz4Ls+0UvEQQ4sfpW8W02cMh4Pg6m7qUVcyjy569zkbT
44tWkAsbCF0LHba0pLDqvpJplRMxL+PBfQZ4JIyVWSDaLeVZxe4mv4JQXsP58UdJ
p6c1o2TIjqrkWVloFCEa0G54ndZNPlWdKGxx+lhaLuOkdjSWL5AF37A1rSPE2bwS
C7BESc5wZiizwE7bA+hHNjsatjDNVaoZr8SY1ejVoHLZLNr9ykOivEYbpJt2tONn
RdZ3ZRNGRqn9h8oTBLU5rlmBUQWDhsiDjfVnpZXklQEBVpoTrAI=
=B0xd
-----END PGP SIGNATURE-----

--Sig_/MktA=Dv1EjHA4CX8vUSTchZ--

--===============2003584969240408755==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2003584969240408755==--
