Return-Path: <SRS0=Rd7Q=OP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A14C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 12:01:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3329661279
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 12:01:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3329661279
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=misterjones.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 760B04B15E;
	Sat, 25 Sep 2021 08:01:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pwd3m4nj2Lxl; Sat, 25 Sep 2021 08:01:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68DF04B136;
	Sat, 25 Sep 2021 08:01:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CBFB4B121
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Sep 2021 08:00:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0AM1daUtC9pQ for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Sep 2021 08:00:58 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 669A34B120
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Sep 2021 08:00:58 -0400 (EDT)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@misterjones.org>)
 id 1mU6MS-00Cvfd-A0; Sat, 25 Sep 2021 13:00:56 +0100
MIME-Version: 1.0
Date: Sat, 25 Sep 2021 13:00:56 +0100
From: Marc Zyngier <maz@misterjones.org>
To: Chenxu Wang <irakatz51@gmail.com>
Subject: Re: Execute "SMC" instruction in Guest OS
In-Reply-To: <CAFLP=uCvQ=xLaMmaSReWWYHC_EBf_k5tf1akp4GLOym9RVRCkw@mail.gmail.com>
References: <CAFLP=uCvQ=xLaMmaSReWWYHC_EBf_k5tf1akp4GLOym9RVRCkw@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <115ea41c2e66382e9b8fb97979e20d91@misterjones.org>
X-Sender: maz@misterjones.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: irakatz51@gmail.com, kvmarm@lists.cs.columbia.edu
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

Hi Chenxu,

On 2021-09-25 07:45, Chenxu Wang wrote:
> Hi all,
> 
> I want the Guest OS to use the Arm-TF service in Host OS (It is the
> same as using Trusted Application in OP-TEE). So I should provide some
> parameters and call SMC instruction.

It is unlikely to work out of the box. For a start, the guest is a
different entity altogether, and it is unlikely that ATF can directly
deal with a request coming from the guest, specially if you are passing
any sort of memory reference.

> But it returns an "Undefined Instruction" in my Linux v4.9.51.
> I find that KVM calls a " kvm_inject_undefined(vcpu);" when handling
> the SMC instruction.

You should really get rid of this kernel and move to something more
recent. This UNDEF injection is a bug which has been fixed in more
recent versions of the kernel (by returning -1 instead).

> So, if I want the Guest OS to use the "Arm-TF service" or "TA", should
> I simply change the kvm_inject_undefined() as "SMC #0", and carefully
> handle the input parameters? What else should I do?

You should probably consider relaying the SMC to userspace, and then get
the VMM to do the talking with with the platform TEE driver.

         M.
-- 
Who you jivin' with that Cosmik Debris?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
