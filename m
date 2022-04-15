Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F2A5C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 06:45:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6C0049EC2;
	Fri, 15 Apr 2022 02:45:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DzLGb5E+Zxjf; Fri, 15 Apr 2022 02:45:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F7CB49EE9;
	Fri, 15 Apr 2022 02:45:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5077D49ED2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 02:45:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f91WMkbU-Neo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 02:45:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B47D49EC2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 02:45:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1650005111;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mVx9cF7b07Hlw+Jyd93aqAlgfIPY+0nd7PYc9dSwC+U=;
 b=UfS9Q+8ugo+f7MBqWRAQh0wo+WSzO1qaYGF785YRZ/N+8duVdAgzSnJIpk4lhsLa9KWw+N
 2D7BRUqrQLbyItApdzvp2Ntc1IH/q9VbJTnMHbW8K9LgeNySdo87Ii0OZez0ULB3s+vl3P
 LVgvYRIHeszkZOTgfgIamck1FG1kNB4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-4Am9g_ddMfCYYooyATDL9w-1; Fri, 15 Apr 2022 02:45:05 -0400
X-MC-Unique: 4Am9g_ddMfCYYooyATDL9w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 283DB801E67;
 Fri, 15 Apr 2022 06:45:05 +0000 (UTC)
Received: from [10.72.13.171] (ovpn-13-171.pek2.redhat.com [10.72.13.171])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C7E040CF8F6;
 Fri, 15 Apr 2022 06:44:58 +0000 (UTC)
Subject: Re: [PATCH v5 00/10] KVM: arm64: Add support for hypercall services
 selection
To: Raghavendra Rao Ananta <rananta@google.com>, Marc Zyngier
 <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20220407011605.1966778-1-rananta@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <92eb2304-9259-0461-247f-d3a4e5eb4fd5@redhat.com>
Date: Fri, 15 Apr 2022 14:44:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20220407011605.1966778-1-rananta@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

Hi Raghavendra,

On 4/7/22 9:15 AM, Raghavendra Rao Ananta wrote:
> Continuing the discussion from [1], the series tries to add support
> for the userspace to elect the hypercall services that it wishes
> to expose to the guest, rather than the guest discovering them
> unconditionally. The idea employed by the series was taken from
> [1] as suggested by Marc Z.
> 
> In a broad sense, the concept is similar to the current implementation
> of PSCI interface- create a 'firmware psuedo-register' to handle the
> firmware revisions. The series extends this idea to all the other
> hypercalls such as TRNG (True Random Number Generator), PV_TIME
> (Paravirtualized Time), and PTP (Precision Time protocol).
> 
> For better categorization and future scaling, these firmware registers
> are categorized based on the service call owners. Also, unlike the
> existing firmware psuedo-registers, they hold the features supported
> in the form of a bitmap.
> 
> During the VM initialization, the registers holds an upper-limit of
> the features supported by each one of them. It's expected that the
> userspace discover the features provided by each register via GET_ONE_REG,
> and writeback the desired values using SET_ONE_REG. KVM allows this
> modification only until the VM has started.
> 
> Some of the standard function-ids, such as ARM_SMCCC_VERSION_FUNC_ID,
> need not be associated with a feature bit. For such ids, the series
> introduced an allowed-list, hvc_func_default_allowed_list[], that holds
> all such ids. As a result, the functions that are not elected by userspace,
> or if they are not a part of this allowed-list, will be denied for when
> the guests invoke them.
> 
> Older VMMs can simply ignore this interface and the hypercall services
> will be exposed unconditionally to the guests, thus ensuring backward
> compatibility.
> 

[...]

I rethinking about the design again and just get one question. Hopefully,
someone have the answer for us. The newly added 3 pseudo registers and
the existing ones like KVM_REG_ARM_PSCI_VERSION are all tied up with
vcpu, instead of VM. I don't think it's correct. I'm not sure if VM-scoped
pseudo registers aren't allowed by ARM architecture or the effort isn't
worthy to support it.

These pseudo registers are introduced to present the available hypercalls,
and then they can be disabled from userspace. In the implementation, these 3
registers are vcpu scoped. It means that multiple vcpus can be asymmetric
in terms of usable hypercalls. For example, ARM_SMCCC_TRNG hypercalls
can be enabled on vcpu0, but disabled on vcpu1. I don't think it's expected.

On the other hand, the information stored in these 3 registers needs to
be migrated through {GET,SET}_ONE_REG by VMM (QEMU). all the information
stored in these 3 registers are all same on all vcpus, which is exactly
as we expect. In migration circumstance, we're transporting identical
information for all vcpus and it's unnecessary.

Thanks,
Gavin



_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
