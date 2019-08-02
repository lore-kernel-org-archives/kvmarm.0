Return-Path: <SRS0=eGRX=V6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C58C32750
	for <kvmarm@archiver.kernel.org>; Fri,  2 Aug 2019 11:32:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D0122087C
	for <kvmarm@archiver.kernel.org>; Fri,  2 Aug 2019 11:32:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D0122087C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3DB54A4EE;
	Fri,  2 Aug 2019 07:32:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SIY575NVBU+o; Fri,  2 Aug 2019 07:32:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1C6A4A52D;
	Fri,  2 Aug 2019 07:32:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 995E74A52D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Aug 2019 07:32:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7QcqisB8OZZU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Aug 2019 07:32:28 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C6674A4EE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Aug 2019 07:32:28 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 8343E5AFD9;
 Fri,  2 Aug 2019 11:32:27 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 98BD25C220;
 Fri,  2 Aug 2019 11:32:25 +0000 (UTC)
Date: Fri, 2 Aug 2019 13:32:22 +0200
From: Andrew Jones <drjones@redhat.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: kvm-unit-tests: psci_cpu_on_test FAILed
Message-ID: <20190802113222.l64u2sauiuxvh6be@kamzik.brq.redhat.com>
References: <3ddf8766-6f02-b655-1b80-d8a7fd016509@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3ddf8766-6f02-b655-1b80-d8a7fd016509@huawei.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.39]); Fri, 02 Aug 2019 11:32:27 +0000 (UTC)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Aug 02, 2019 at 06:56:51PM +0800, Zenghui Yu wrote:
> Hi folks,
> 
> Running kvm-unit-tests with Linux 5.3.0-rc2 on Kunpeng 920, we will get
> the following fail info:
> 
> 	[...]
> 	FAIL psci (4 tests, 1 unexpected failures)
> 	[...]
> and
> 	[...]
> 	INFO: unexpected cpu_on return value: caller=CPU9, ret=-2
> 	FAIL: cpu-on
> 	SUMMARY: 4 tests, 1 unexpected failures
> 
> 
> I think this is an issue had been fixed once by commit 6c7a5dce22b3
> ("KVM: arm/arm64: fix races in kvm_psci_vcpu_on"), which makes use of
> kvm->lock mutex to fix the race between two PSCI_CPU_ON calls - one
> does reset on the MPIDR register whilst another reads it.
> 
> But commit 358b28f09f0 ("arm/arm64: KVM: Allow a VCPU to fully reset
> itself") later moves the reset work into check_vcpu_requests(), by
> making a KVM_REQ_VCPU_RESET request in PSCI code. Thus the reset work
> has not been protected by kvm->lock mutex anymore, and the race shows up
> again...
> 
> Do we need a fix for this issue? At least achieve a mutex execution
> between the reset of MPIDR and kvm_mpidr_to_vcpu()?
> 
>

I noticed this too, but I put it pretty low on my TODO because it's a
safe failure (no host crash, just an unexpected PSCI_RET_INVALID_PARAMS
gets returned because the valid MPIDR doesn't look valid for a moment.)
Also, the test is quite pathological, especially when the host has many
CPUs, so I wouldn't expect this to show up on a sane guest. I agree
it would be nice to get it fixed eventually though.

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
