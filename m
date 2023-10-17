Received: from out-201.mta0.migadu.com (out-201.mta0.migadu.com [91.218.175.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F6F847E
	for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 08:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UM5zdtV7"
Date: Tue, 17 Oct 2023 08:03:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697529798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X41/o5bczvtn2r8r9l6vgC27CyrOUvCR36syb0XC5bs=;
	b=UM5zdtV751wdwKI/Wqjsx9D6o9Ry46UF+LP/DwUf+aJ3hMmNjco/o3FyR68ou4P+IDOxqL
	PJB3/NrbCLGk/n6EWyRDvB7ts1fy4wHu38hWOk7TaX5IdJKUjiEKpajU5M6w7s9wHh3sBa
	LCA9ccbRxTh6daV0+xAJocAcyFtH8MY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>,
	Jing Zhang <jingzhangos@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 5/5] KVM: arm64: selftests: Test for setting ID
 register from usersapce
Message-ID: <ZS4_wGJPg3G8dA7Z@linux.dev>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-6-oliver.upton@linux.dev>
 <87fs2aegap.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fs2aegap.fsf@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 16, 2023 at 05:30:06PM +0200, Cornelia Huck wrote:
> On Wed, Oct 11 2023, Oliver Upton <oliver.upton@linux.dev> wrote:
> 
> > From: Jing Zhang <jingzhangos@google.com>
> >
> > Add tests to verify setting ID registers from userspace is handled
> > correctly by KVM. Also add a test case to use ioctl
> > KVM_ARM_GET_REG_WRITABLE_MASKS to get writable masks.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../selftests/kvm/aarch64/set_id_regs.c       | 479 ++++++++++++++++++
> >  2 files changed, 480 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c
> 
> (...)
> 
> > +static void test_user_set_reg(struct kvm_vcpu *vcpu, bool aarch64_only)
> > +{
> > +	uint64_t masks[KVM_ARM_FEATURE_ID_RANGE_SIZE];
> > +	struct reg_mask_range range = {
> > +		.addr = (__u64)masks,
> > +	};
> > +	int ret;
> > +
> > +	/* KVM should return error when reserved field is not zero */
> > +	range.reserved[0] = 1;
> > +	ret = __vm_ioctl(vcpu->vm, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);
> > +	TEST_ASSERT(ret, "KVM doesn't check invalid parameters.");
> 
> I think the code should first check for
> KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES -- newer kselftests are supposed
> to be able to run on older kernels, and we should just skip all of this
> if the API isn't there.

Ah, thanks! I'll apply the following on top:

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index 5c0718fd1705..bac05210b539 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -452,6 +452,8 @@ int main(void)
 	uint64_t val, el0;
 	int ftr_cnt;
 
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES));
+
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	/* Check for AARCH64 only system */

-- 
Thanks,
Oliver
