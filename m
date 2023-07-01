Received: from out-29.mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C56A3C3E
	for <kvmarm@lists.linux.dev>; Sat,  1 Jul 2023 17:42:34 +0000 (UTC)
Date: Sat, 1 Jul 2023 10:42:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1688233353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tnh9qdBnPUJuyMP1cG7zLaM8l1NgjvNEN4PkBGU4vkU=;
	b=tdnWnAZcA7JaHuDZjJECWw7KaOiLwNknOOwUd0rW7qDnCpfJLQm7G9i6My3oi+x8p5zPUq
	9aS1FqKNHFDZETcvrHeQ0BvwfUHFIAnGqsJGozHYTR+92Z6BmeEH7ycv3NWgNrn5xHAiiJ
	V5xSO2UCoDIumuHaArArEfScg+zmgmE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, isaku.yamahata@intel.com,
	seanjc@google.com, pbonzini@redhat.com, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>
Subject: Re: KVM CPU hotplug notifier triggers BUG_ON on arm64
Message-ID: <ZKBlhJwl9YD5FHvs@linux.dev>
References: <aeab7562-2d39-e78e-93b1-4711f8cc3fa5@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeab7562-2d39-e78e-93b1-4711f8cc3fa5@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Kristina,

Thanks for the bug report.

On Sat, Jul 01, 2023 at 01:50:52PM +0100, Kristina Martsenko wrote:
> Hi,
> 
> When I try to online a CPU on arm64 while a KVM guest is running, I hit a
> BUG_ON(preemptible()) (as well as a WARN_ON). See below for the full log.
> 
> This is on kvmarm/next, but seems to have been broken since 6.3. Bisecting it
> points at commit:
> 
>   0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock")

Makes sense. We were using a spinlock before, which implictly disables
preemption.

Well, one way to hack around the problem would be to just cram
preempt_{disable,enable}() into kvm_arch_hardware_disable(), but that's
kinda gross in the context of cpuhp which isn't migratable in the first
place. Let me have a look...

--
Thanks,
Oliver
