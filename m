Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF09A5349AA
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 10:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790073001; cv=none; b=jZaS+WjkNHTkjT6+3KXqFuVbXYAghC9rupCzAn8apAsrvlyc3zk6butfi4rNLmW+NTgQFZRsBqCJFj9uIt4EBr5ZRlBgfVxyqK+nlGmpjJuIjnJrV2xSAjQwWRQN9d46L22XW274eai/MxLyriYWzkpkXx3iw1/UV76ar0kU6Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790073001; c=relaxed/simple;
	bh=EU3Txp/UGRjh2pRsCyRZx8UrLqTSartVJ+lbptajdrw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GiFkOrelLfto690VcTdUlD96mvwJAaFRCrH7RMmeoT+kUp+oVJN1imanBEEdW3WMId1uFYeIWUOF8qYedb89m5o305nLX3HWF9ZRqm+6c+0AfgJ72NVYMLJqz/hvXBxewvN7IKRWr2Kh3SETCdYToYH7ch0/YlSbAj2ULZg5snM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aYezXlDT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aYezXlDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FFA1F000FF;
	Tue, 22 Sep 2026 10:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790072999;
	bh=7NPN9Jv2/oZER2vhQsZqdknzJETKpz3kfhHZeoW/u4M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aYezXlDTDHb840oDtEQ5PohfeMO1n2bVewJpuR693AhxwIqlGoiVY1QIH0Dk8BnGk
	 GNyj7cg7JmvlHX9NtRWXQNTRhUIVhBtFjI45EPmXSY9o8aTGMkC7ljtpSiYM5zLaZI
	 jVTPxNh7ODC0O2ZhgoId/BUApoy2hpt//c5je5RZsLEBFNgl+PwJMJXv0d5XiYs6ix
	 6RcxF2HYly6sahKy/pgpc0WpyiIWwLUd1wew7iLxkMBsmpD5OId0CIloyQtWp0TXYp
	 eXteDD7raluPKLehEf/E5XH8n+ly2h7AlvjFRbvj0L3VF/IAyaz1n4GE/SSJdvJLqf
	 L1WonV6PzTYuA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: selftests: arm64: Add test for cross-vCPU LPI
 disable race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuchao Zhang" <ndaugoing@gmail.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260922101632.39497-1-ndaugoing@gmail.com>
References: <87bj9r4h9z.wl-maz@kernel.org>
 <20260922101632.39497-1-ndaugoing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 10:29:58 +0000
Message-Id: <20260922102959.41FFA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] kvm: selftests: buffer overflow in configure_lpis() via large ev=
ent_ids
- [Medium] kvm: selftests: ITS command error due to INVALL/SYNC on unmapped=
 collection
- [Medium] kvm: selftests: silently ignored MSI injection failures in signa=
l_lpi()
--

commit c5682a23bdbe7c62a7e95d362e2d340ff25c1e42
Author: Yuchao Zhang <ndaugoing@gmail.com>

KVM: selftests: arm64: Add test for cross-vCPU LPI disable race

This commit adds a selftest to validate the behavior of remote LPI
disabling while the target vCPU has in-flight or overflowing LPIs. It
configures an ITS with multiple LPIs targeting vCPU 0, while vCPU 1
toggles GICR_CTLR.EnableLPIs.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_disable.c b/tools=
/testing/selftests/kvm/arm64/vgic_lpi_disable.c
> new file mode 100644
> index 0000000000000..0781349192288
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_disable.c
> @@ -0,0 +1,401 @@
[ ... ]
> +static void guest_setup_its_mappings(void)
> +{
> +	u32 device_id, event_id, intid =3D GIC_LPI_OFFSET;
> +	u32 nr_events =3D test_data.nr_event_ids;
> +	u32 nr_devices =3D test_data.nr_devices;
> +
> +	/* Map collection 0 to TARGET_VCPU_ID */
> +	its_send_mapc_cmd(test_data.cmdq_base_va, TARGET_VCPU_ID, TARGET_VCPU_I=
D, true);
> +
> +	/* Map all LPIs to TARGET_VCPU_ID to force LR overflow */
[ ... ]
> +static void guest_invalidate_all_rdists(void)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < test_data.nr_cpus; i++)
> +		its_send_invall_cmd(test_data.cmdq_base_va, i);
> +}

[Severity: Medium]
Will sending an INVALL command for CPU ID 1 act as a command error since
collection 1 was never mapped?=20

In guest_setup_its_mappings(), only collection 0 is mapped to TARGET_VCPU_I=
D,
but this loop iterates over all CPUs (collections 0 and 1) and sends INVALL.

[ ... ]
> +static void guest_setup_gic(void)
> +{
[ ... ]
> +	guest_setup_its_mappings();
> +	guest_invalidate_all_rdists();
> +
> +	/* SYNC to ensure ITS setup is complete */
> +	for (cpuid =3D 0; cpuid < test_data.nr_cpus; cpuid++)
> +		its_send_sync_cmd(test_data.cmdq_base_va, cpuid);
> +}

[Severity: Medium]
Similarly, does issuing a SYNC command for cpuid 1 cause an architectural
command error here, given that collection 1 remains unmapped?=20

This might cause the virtual ITS command queue to stall.

[ ... ]
> +static void configure_lpis(void)
> +{
> +	size_t nr_lpis =3D test_data.nr_devices * test_data.nr_event_ids;
> +	u8 *tbl =3D addr_gpa2hva(vm, test_data.lpi_prop_table);
> +	size_t i;
> +
> +	for (i =3D 0; i < nr_lpis; i++) {
> +		tbl[i] =3D LPI_PROP_DEFAULT_PRIO |
> +			 LPI_PROP_GROUP1 |
> +			 LPI_PROP_ENABLED;
> +	}
> +}

[Severity: Medium]
Can this loop overflow the lpi_prop_table allocation?=20

The table is allocated a fixed 64KB size in setup_test_data(), but
test_data.nr_event_ids is read directly from the command line argument in
main() via atoi_positive(). A large user input could cause an out-of-bounds
write here since the value isn't bounds-checked to fit within the region.

[ ... ]
> +static void signal_lpi(u32 device_id, u32 event_id)
> +{
> +	gpa_t db_addr =3D GITS_BASE_GPA + GITS_TRANSLATER;
> +
> +	struct kvm_msi msi =3D {
> +		.address_lo	=3D db_addr,
> +		.address_hi	=3D db_addr >> 32,
> +		.data		=3D event_id,
> +		.devid		=3D device_id,
> +		.flags		=3D KVM_MSI_VALID_DEVID,
> +	};
> +
> +	__vm_ioctl(vm, KVM_SIGNAL_MSI, &msi);
> +}

[Severity: Medium]
Is it safe to ignore the return value of __vm_ioctl() here?=20

If KVM_SIGNAL_MSI fails (for example, if the ITS command queue stalls due
to the unmapped collection mentioned earlier), the failure is silently mask=
ed.=20
This could cause the test to spin without triggering the intended overflow
path, falsely reporting success on a broken test environment.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922101632.3949=
7-1-ndaugoing@gmail.com?part=3D1
