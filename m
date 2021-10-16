Return-Path: <SRS0=NFrk=PE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DAAC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 16 Oct 2021 12:21:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 448B6604E9
	for <kvmarm@archiver.kernel.org>; Sat, 16 Oct 2021 12:21:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 448B6604E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B017B4B17C;
	Sat, 16 Oct 2021 08:21:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DGViESZt+E8W; Sat, 16 Oct 2021 08:21:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 983524B163;
	Sat, 16 Oct 2021 08:21:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C1934B161
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Oct 2021 08:21:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0vhGKLGQEKV2 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 Oct 2021 08:21:13 -0400 (EDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com
 [209.85.167.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F2E94B101
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Oct 2021 08:21:13 -0400 (EDT)
Received: by mail-lf1-f48.google.com with SMTP id g36so37187875lfv.3
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Oct 2021 05:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:from:date:message-id:subject:to;
 bh=iUsr9p51Ie9nTNReJyDuQVS1DebemxHDbn7P2Mm5pXs=;
 b=RVWgKFLdjFF1i2II4GFThAAPdzf0tRhrhJEbMk5xQBNoG6l+4NHNqTIzSF5u6h5w1j
 s4HIiO5RJIRk31vIgWt3WzY3+AQhy6sTx06CER8vkBKOKzd5TK8tfx5/xkuOZAedVHfq
 OytyyWDpuK2nfyhK6fcioymNognHgUyEhG2GKzKFpMiYxRFcqGweKro7aNbZhpLmhYAU
 RA4uqXf/AsQ9VEx4Ghct4MurPAYYLKuOOuCLegzrZRUErm1SL7z3neplxsVXN+sNqhmx
 lyK91HCV25k+C8sItCRoXqXNyWh17ehmjN6h1daQGFIBOzhQyN5CqbIoYOjkatRYqXd5
 5zIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=iUsr9p51Ie9nTNReJyDuQVS1DebemxHDbn7P2Mm5pXs=;
 b=4b3I0vwmBwP6TYRGjvXVqNkrBd/2XQlWOBd739xffC05Vs6UYT5dgW4M4Ly/8Y0h5M
 hjqdP+xvZvLyeC95sXB1/KtQ1Tc60GtA4+9ZEzeddzVNUoY7vSj/2vvOKDgkO/iLsf12
 VTUgf4yqVFSTdhdB2VG2I4BXXnY6cbHwmokB2rDw1FY3oMXrnvYxO7Iq5IGRft1L2UbU
 G5kcXADY3AFa0SyBAdXRAE5Aome3wlHR9Gvd0TBEXuqoMVh/VU99KvIxG9o7cpRqOOy6
 /gMhqfNhQnTbKbjxCd2EAcR+dK8cD+40m0BGUR7jYSC27ULYygMFtHvUxuLCTNllYvIn
 gr5g==
X-Gm-Message-State: AOAM530L0rvnQdEvbRJAoOt44IbER/bjmaAwSMBb7qlFpXNRHlaemhv1
 DA06GQZ7LolyJ3TVao6o6O0ctT9vaL8CyUdqRsxkKhm/AcA=
X-Google-Smtp-Source: ABdhPJyNMw87cIluDBDWmb3yyIKbAtITw2OWYhw1bqS5MUEqPXPxcdmhPx6OaDoCWTcXDgbUxtuqHxNpL4qo5HwezQ0=
X-Received: by 2002:ac2:5934:: with SMTP id v20mr18095497lfi.605.1634386871931; 
 Sat, 16 Oct 2021 05:21:11 -0700 (PDT)
MIME-Version: 1.0
From: Chenxu Wang <irakatz51@gmail.com>
Date: Sat, 16 Oct 2021 20:21:01 +0800
Message-ID: <CAFLP=uDhb8Zq5pAnTbvXi_OU047Uw3WRkw2YJsYNEsCkdHzkJQ@mail.gmail.com>
Subject: Problems about Stage-2 translation
To: kvmarm@lists.cs.columbia.edu
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
Content-Type: multipart/mixed; boundary="===============4513698973765541506=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============4513698973765541506==
Content-Type: multipart/alternative; boundary="000000000000ed561d05ce77583f"

--000000000000ed561d05ce77583f
Content-Type: text/plain; charset="UTF-8"

Hi all,

I am facing two problems with the Stage-2 translation in KVM.

(1)
I reserve a memory region (e.g., 0xa000_0000 ~ 0xa020_0000) from DRAM space
of HostOS, and fill it with some values. Then ask a GuestVM to access this
region.

void __iomem *region=ioremap(0xa0000000, 0x1000);
uint32_t val=ioread32(region);

But I get value 0, which is not the expected value.
I guess the reason is that the Stage-2 translation of the GuestVM does not
map the reserved region, but it should return a translation fault, rather
than 0. So I feel confused, could you provide some helpful explanation?

(2)
I consider mapping a region with the Stage-2 translation. I find that KVM
create the stage-2 table with kvm_alloc_stage2_pgd(). But I could not find
a function that can "arbitrarily add a stage-2 mapping to the physical
address in HostOS" when the VM is activated.

Could you provide such functions?

--000000000000ed561d05ce77583f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi all,<div><br></div><div>I am facing two problems with t=
he Stage-2 translation in KVM.=C2=A0</div><div><br></div><div>(1)</div><div=
>I reserve a memory region (e.g., 0xa000_0000 ~ 0xa020_0000) from DRAM spac=
e of HostOS, and fill it with some values. Then ask a GuestVM to access thi=
s region.<br></div><div><br></div><div>void __iomem *region=3Dioremap(0xa00=
00000, 0x1000);<br>uint32_t val=3Dioread32(region);<br></div><div><br></div=
><div>But I get value 0, which is not the expected value.</div><div>I guess=
 the reason is that the Stage-2 translation of the GuestVM does not map the=
 reserved region, but it should return a translation fault, rather than 0. =
So I feel confused, could you provide some helpful explanation?</div><div><=
br></div><div>(2)</div><div>I consider mapping a region with the Stage-2 tr=
anslation. I find that KVM create the stage-2 table with=C2=A0kvm_alloc_sta=
ge2_pgd(). But I could not find a function that=C2=A0can &quot;arbitrarily =
add a stage-2 mapping to the physical address in HostOS&quot; when the VM i=
s activated.=C2=A0</div><div><br></div><div>Could you provide such function=
s?</div></div>

--000000000000ed561d05ce77583f--

--===============4513698973765541506==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4513698973765541506==--
