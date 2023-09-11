Received: from out-230.mta1.migadu.com (out-230.mta1.migadu.com [95.215.58.230])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD2311C87
	for <kvmarm@lists.linux.dev>; Mon, 11 Sep 2023 15:59:16 +0000 (UTC)
Message-ID: <963a899d-d25a-368f-1465-851787c25959@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1694447954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UWGx8nOe8UMiBtiPfiV0PpeEd8UXtwFSIc0awgSTnuM=;
	b=PTq8pYHKGyxAQ1Loh2IKxBsBNTnU1jI78EQH7m5D4j7ZaoK3folTH6rtJGyjpE2fcB7SyH
	fkkyU6heVJkLwN5BD2gA48F0Kv9OJihdLzz4iFxMsbKc2TGg4O4wOuyrfj81awE85s4tlz
	xyXERjf+ougQ5lZK4ULixkULhYKsUAE=
Date: Mon, 11 Sep 2023 23:57:39 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] KVM: arm64: vgic-v3: Refactor GICv3 SGI generation
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Xu Zhao <zhaoxu.35@bytedance.com>
References: <20230907100931.1186690-1-maz@kernel.org>
 <20230907100931.1186690-5-maz@kernel.org>
 <fd96f034-b7ca-c1bd-a94e-06f8e84e52a7@linux.dev>
 <87ledd51tu.wl-maz@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <87ledd51tu.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2023/9/11 02:18, Marc Zyngier wrote:
> On Sun, 10 Sep 2023 17:25:36 +0100,
> Zenghui Yu <zenghui.yu@linux.dev> wrote:
>>
>> Hi Marc,
>>
>> I asked because it seems that in kvm/arm64 we always use
>> kvm_get_vcpu(kvm, i) to obtain the kvm_vcpu pointer, even if *i* is
>> sometimes essentially provided by userspace..
> 
> Huh, this is incredibly dodgy. I had a go at a few occurrences (see
> below), but this is hardly a complete list.

Another case is all kvm_get_vcpu(kvm, target_addr) in the vgic-its
emulation code. As we expose GITS_TYPER.PTA=0 to guest, which indicates
that the target address corresponds to the PE number specified by
GICR_TYPER.Processor_Number, which is now encoded as vcpu->vcpu_id.

Thanks,
Zenghui
