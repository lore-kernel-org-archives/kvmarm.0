Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F0AC433EF
	for <kvmarm@archiver.kernel.org>; Sat,  4 Jun 2022 08:06:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39FD64B2CA;
	Sat,  4 Jun 2022 04:06:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@misterjones.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UdJpoNdnNZEC; Sat,  4 Jun 2022 04:06:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4A2C4B293;
	Sat,  4 Jun 2022 04:06:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88BD143399
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Jun 2022 04:06:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gIWESpdKQihY for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Jun 2022 04:06:04 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD1B64B103
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Jun 2022 04:06:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=misterjones.org; s=dkim20211231; h=Content-Transfer-Encoding:Content-Type:
 Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
 :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
 Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
 List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=52/5nG/P9nfcpdWEk3UGv2UinfOs9ZZsOf+0nrjVg8A=; b=aKChAJMWawPgflhb8O+Y0WZ9xw
 ThKl0IKQaWcv3CuHUJSHPM2KY8y7N+5qlPaOzDW4+Vrd/ERl0xt86TSdWCq9of39Qd/lhP0jXdTze
 M7wHW5KeeuOoo9xo0Tlr7v/i4F5QTX0WdLgI+TTpB2iBx7oZIV9H3oOQTj6/rcS9MgJu3rXymFh5q
 g2d8o5+69vG+8t9YcCz0WvWJmW80tU6urn6lGjYXe/slurX3GXwGk5OCU4Yr99bVndEaI6Fu0lUrY
 rAoJZgAnVQ9Ohi+PZleUAc/KipyjPCppVYLs5GPBz3tF7rK7/CvK9Y/l4iHgPJ+vksjHsX3c82U9a
 iZERWiuA==;
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@misterjones.org>)
 id 1nxOnK-00FaBy-Kk; Sat, 04 Jun 2022 09:06:02 +0100
MIME-Version: 1.0
Date: Sat, 04 Jun 2022 09:06:02 +0100
From: Marc Zyngier <maz@misterjones.org>
To: Ivan Masum <heromasum@gmail.com>
Subject: Re: Need to run kvm/qemu on ARM
In-Reply-To: <CAEVNJ6vPN1nv1ec2r_SupYaKR6o0prgaO765y2W1Ltf+SMDwBw@mail.gmail.com>
References: <CAEVNJ6vPN1nv1ec2r_SupYaKR6o0prgaO765y2W1Ltf+SMDwBw@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <cb0ac8bd782b8672ac6938f563e5a6ba@misterjones.org>
X-Sender: maz@misterjones.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: heromasum@gmail.com, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2022-06-03 04:41, Ivan Masum wrote:
> Hello team,
> I am a new fee in linux. Recently i am using oracle cloud free tier
> with 4core 24gb ram. I am learning Devops. So i need many virtual
> machine. How do i easily install kvm or qemu on arm machine while
> oracle not suppot virtualization?

I assume that what you get from Oeacle is itself a VM.

You can't run KVM inside a VM, as neither the HW provided
by Oracle nor KVM itself support nested virtualisation.

As for running QEMU, that's no different from any other
architecture, and you may want to have a look at the QEMU
documentation (which is fairly exhaustive).

> I whould like to hear the solution from you. Morover how do i contact
> with you in quick chat?

This mailing list is the way to get in touch with people
working on KVM/arm64.

Thanks,

         M.
-- 
Who you jivin' with that Cosmik Debris?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
