Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D103911C3
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 17:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786122046; cv=none; b=XsJYHojP1yNXMy2lF51S4K5f7U8TGAKPJEyAw6nRl4K/HzQzq1BztiCYhqgP3usp0Nasy2ApWNF2Eisj3caNKYttK63nDD1rZS0GkPrvqu/CMwKidcJObN/Jm0htU9XgCzYevHuzSQglqsCv30zUc7eOhPwfv5JcfYW6SiHCfFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786122046; c=relaxed/simple;
	bh=GrQ5dHVAZB5MtK4NH4VzhXzX9E/YxQ0v1dkg3kyIgCg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PWed3WsLqA4r6dzLKzNeiVA7pjaznWXk6tYmuQ0KjHTmsT9pCf64nV93R4aoamuzDO2pCEqoNIMPGBy+6RxylG0flsOmA70j9J54xNklC3QEzoMOPRrGXanI9ov1UKylf2Cemo/5JafWzWDrXot47b1oxjw8EKs2TmDyopHnrdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=erS69uC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="erS69uC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B771F000E9;
	Fri,  7 Aug 2026 17:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786122045;
	bh=moOPuuv2xPeUjXWGA0soBbSuQbc7UJcwYRhWxCOBSYg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=erS69uC9F+At9k4hDRpnFt+LUvbSDeqeJZtJOeHbolLEaNxqgOmX849iemGQAWSLi
	 jkUHKwrJBXZTSY2620tXcKY6yY4wmwWKlERWNAEoJCe2VO4RlZTJM1by1avjdDkue8
	 e2MyWBFPfgcfHQTIK8VqCQ+EEvQV3IVfKjRvoYBJjJqDrmjq09HA4xKVJTshGegaSu
	 jFqZ7qBOlAn4RZGNgUaXC3mV9OpkjRBK7eXKoam4/7rQudqYk+21h1wmWETnL2E9KC
	 UiBpU43QLTqhfxh25OwEyaR7kzibAlm/FEMHD70VpCojx38l0JjCnFFXg8E2imTJMo
	 xQ8lr4xZXwxUg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/13] irqchip/gic-v3-its: Add support for the ITS
 emulation setup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260807164322.2970811-7-sebastianene@google.com>
References: <20260807164322.2970811-2-sebastianene@google.com>
 <20260807164322.2970811-7-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:00:44 +0000
Message-Id: <20260807170044.B1B771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] The intended API design dictates calling `on_each_cpu()` while har=
dware interrupts are disabled, which triggers SMP deadlocks.
- [High] Page allocations are performed while holding raw spinlocks, violat=
ing PREEMPT_RT lock nesting rules and causing 'sleeping while atomic' panic=
s.
- [High] Partial failure during ITS emulation setup leaves the system in a =
broken, partially-emulated state with no rollback.
- [Medium] Defensive check `WARN_ON(!flags)` in `its_emulate_release_locks`=
 leads to a NULL pointer dereference and unbalanced unlocks on the error pa=
th.
- [Medium] Acquiring an unbounded number of identical locks triggers lockde=
p's same-lock-class tracking.
--

--- Patch [5]: [PATCH v2 05/13] irqchip/gic-v3-its: Add support for the ITS=
 emulation setup ---
commit 96beb9b6951a65e060abceadeb7be17ef57b5218
Author: Sebastian Ene <sebastianene@google.com>

irqchip/gic-v3-its: Add support for the ITS emulation setup

This commit introduces helper functions to lock the ITS and duplicate its s=
tate
for pKVM emulation. It allows an emulation layer to hide original hardware
tables and command queues from the host.

> pkvm_drop_host_privileges()
>         its_emulate_acquire_locks(&flags);
>                 on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
>         its_emulate_release_locks(ret, &flags, pkvm_its_emulate_setup);

[Severity: High]
Will this sequence trigger a deadlock? its_emulate_acquire_locks() uses
raw_spin_lock_irqsave(), disabling local interrupts. Calling on_each_cpu()
sends cross-CPU IPIs and waits for completion, which is strictly
prohibited while interrupts are disabled because the local CPU cannot
process incoming IPIs.

> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v=
3-its.c
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c

[ ... ]

> +static struct its_host_state *its_snapshot_host_state(struct its_node *i=
ts)
> +{
> +	void *page;
> +	struct its_host_state *snapshot;
> +	int i;
> +
> +	page =3D its_alloc_pages_node(its->numa_node, GFP_ATOMIC | __GFP_ZERO, =
0);

[Severity: High]
Is it safe to call the page allocator here? This function is called from
its_emulate_switch_queues_locked() inside the its_emulate_release_locks()
loop, where both the global its_lock and the local its->lock raw spinlocks
are held.

Even with GFP_ATOMIC, the page allocator acquires zone->lock, which is a
sleeping rt_mutex on PREEMPT_RT kernels. Acquiring a sleepable lock while
holding a raw spinlock causes a sleeping while atomic panic.

[ ... ]

> +void its_emulate_acquire_locks(unsigned long *flags)
> +{
> +	struct its_node *its;
> +
> +	if (WARN_ON(!flags))
> +		return;
> +
> +	raw_spin_lock_irqsave(&its_lock, *flags);
> +
> +	list_for_each_entry(its, &its_nodes, entry)
> +		raw_spin_lock(&its->lock);
> +}

[Severity: Medium]
Does holding all these identical locks concurrently trigger lockdep? Since
all its->lock instances belong to the same lock class, acquiring an
unbounded number of them sequentially without unlocking or using nested
annotations will trigger lockdep's same-lock-class tracking and disable
further lockdep checks.

> +int its_emulate_release_locks(int ret_pkvm_finalize, unsigned long *flag=
s, its_emulate_setup cb)
> +{
> +	struct its_node *its;
> +	int ret =3D 0;
> +
> +	if (WARN_ON(!flags || !cb))
> +		ret =3D -EINVAL;
> +
> +	list_for_each_entry(its, &its_nodes, entry) {
> +		if (!ret_pkvm_finalize && !ret)
> +			ret =3D its_emulate_switch_queues_locked(its, cb);
> +
> +		raw_spin_unlock(&its->lock);
> +	}
> +
> +	raw_spin_unlock_irqrestore(&its_lock, *flags);
> +
> +	return ret;
> +}

[Severity: Medium]
If flags is NULL, the WARN_ON triggers and sets ret =3D -EINVAL, but execut=
ion
continues. Doesn't this lead to a NULL pointer dereference in
raw_spin_unlock_irqrestore() at the end of the function, as well as
unbalanced unlocks for all its->lock instances (since the acquire
function returns early)?

[Severity: High]
If its_emulate_switch_queues_locked() fails for a node, ret is populated
and subsequent nodes are skipped. However, what happens to the nodes that
were already successfully switched?=20

Without rolling back the hardware state for those previous nodes, the
system is left partially emulated, which would cause a loss of
synchronization between the driver and hardware and lead to IOMMU or
interrupt faults.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807164322.2970=
811-2-sebastianene@google.com?part=3D5
