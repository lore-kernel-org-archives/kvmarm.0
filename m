Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C277C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 08:05:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB0C74B11C;
	Wed,  8 Dec 2021 03:05:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O8xSgP8SHSyi; Wed,  8 Dec 2021 03:05:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34C624B10A;
	Wed,  8 Dec 2021 03:05:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F339C4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 03:05:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DeGwT-ekjjqP for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 03:05:19 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85DDE4B099
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 03:05:19 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id C865DB81FDB;
 Wed,  8 Dec 2021 08:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C26C00446;
 Wed,  8 Dec 2021 08:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638950716;
 bh=KiAE85J9E4RUuyics28Az+nBcidehxYeo/Lbw+wpMQY=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=ObTiW/Vz3YU9qpZmKY/k1mWzpvBI5obIV7BpJjWxDrGUTLpu2T7uPxOJDOrKQwOa4
 tnbDOPwipMkj/0NJu6iKdUlQtW6QU+UkQftQsaCulBsbB0NVcVQH5iz8AtqMkO4s3C
 Fp3s4Fd1ukqWEahHrvBJ8gZ9l5Uzg2Bd+vAr/N6u/kFr8mn+ndy+zfed/bbI2IKoh4
 eoafLHuTBkbaIcFmuNoww57QAcvX//nC/h2lbkHLHrr+DZeS7mKQs2TTn006OJQygL
 ZIm6bTdyjYmoPlnSabfELxY9TyO5fq9wBAyN1JMHt6DFktdWQOQKfVTMfDdzLkyDfU
 mLScl4bVfhjMw==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1murww-00AiF1-Mq; Wed, 08 Dec 2021 08:05:14 +0000
MIME-Version: 1.0
Date: Wed, 08 Dec 2021 08:05:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Improve PMU support on heterogeneous
 systems
In-Reply-To: <CAAeT=FygprcS3YxbVaW+4yUjHBm8=MxZ+j4_iVjq7ie-ppRKRg@mail.gmail.com>
References: <20211206170223.309789-1-alexandru.elisei@arm.com>
 <CAAeT=FygprcS3YxbVaW+4yUjHBm8=MxZ+j4_iVjq7ie-ppRKRg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <addac215bddf0b86bf6850093d500785@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: reijiw@google.com, alexandru.elisei@arm.com,
 james.morse@arm.com, suzuki.poulose@arm.com, will@kernel.org,
 mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, tglx@linutronix.de, mingo@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: will@kernel.org, mingo@redhat.com, tglx@linutronix.de,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Reji,

On 2021-12-08 02:36, Reiji Watanabe wrote:
> Hi Alex,
> 
> On Mon, Dec 6, 2021 at 9:02 AM Alexandru Elisei
> <alexandru.elisei@arm.com> wrote:
>> 
>> (CC'ing Peter Maydell in case this might be of interest to qemu)
>> 
>> The series can be found on a branch at [1], and the kvmtool support at 
>> [2].
>> The kvmtool patches are also on the mailing list [3] and haven't 
>> changed
>> since v1.
>> 
>> Detailed explanation of the issue and symptoms that the patches 
>> attempt to
>> correct can be found in the cover letter for v1 [4].
>> 
>> A brief summary of the problem is that on heterogeneous systems KVM 
>> will
>> always use the same PMU for creating the VCPU events for *all* VCPUs
>> regardless of the physical CPU on which the VCPU is running, leading 
>> to
>> events suddenly stopping and resuming in the guest as the VCPU thread 
>> gets
>> migrated across different CPUs.
>> 
>> This series proposes to fix this behaviour by allowing the user to 
>> specify
>> which physical PMU is used when creating the VCPU events needed for 
>> guest
>> PMU emulation. When the PMU is set, KVM will refuse to the VCPU on a
>> physical which is not part of the supported CPUs for the specified 
>> PMU.
> 
> Just to confirm, this series provides an API for userspace to request
> KVM to detect a wrong affinity setting due to a userspace bug so that
> userspace can get an error at KVM_RUN instead of leading to events
> suddenly stopping, correct ?

More than that, it allows userspace to select which PMU will be used
for their guest. The affinity setting is a byproduct of the PMU's own
affinity.

> 
>> The default behaviour stays the same - without userspace setting the 
>> PMU,
>> events will stop counting if the VCPU is scheduled on the wrong CPU.
> 
> Can't we fix the default behavior (in addition to the current fix) ?
> (Do we need to maintain the default behavior ??)

Of course we do. This is a behaviour that has been exposed to userspace
for years, and *we don't break userspace*.

> IMHO I feel it is better to prevent userspace from configuring PMU
> for guests on such heterogeneous systems rather than leading to
> events suddenly stopping even as the default behavior.

People running KVM on asymmetric systems *strongly* disagree with you.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
