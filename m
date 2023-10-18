Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A6C34CDF
	for <kvmarm@lists.linux.dev>; Wed, 18 Oct 2023 12:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I4zlpqSv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697632518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lz7XMhYS02Gm6gaNbc9MQCWSsb5Mo/qLQc74Gx24w/Y=;
	b=I4zlpqSvavioGEy0VdcYCAi0Ro92adzcc5KJAI+00dEEsnBaxQ97rbqU1v63JGzmQtg6r/
	/FdGctMDUL21JWLFtH0ePOKftukjg0ccNQkOEvCdIhPSCheiv7n3vFHWzz0EQYLWmRbLs2
	Zacipc/ZNR2RFV3N7uAE2Gn8xaQthIg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-S5U5UdzuNTiPHi-fdTr-cw-1; Wed, 18 Oct 2023 08:35:05 -0400
X-MC-Unique: S5U5UdzuNTiPHi-fdTr-cw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E544C886C62;
	Wed, 18 Oct 2023 12:35:03 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5055B2166B28;
	Wed, 18 Oct 2023 12:35:03 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org,
 Mark Brown <broonie@kernel.org>, Jing Zhang <jingzhangos@google.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>, Marc Zyngier
 <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Adrian Hunter
 <adrian.hunter@intel.com>, Ian Rogers <irogers@google.com>, Namhyung Kim
 <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Alexander Shishkin
 <alexander.shishkin@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 5/5] KVM: arm64: selftests: Test for setting ID
 register from usersapce
In-Reply-To: <ZS4_wGJPg3G8dA7Z@linux.dev>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-6-oliver.upton@linux.dev>
 <87fs2aegap.fsf@redhat.com> <ZS4_wGJPg3G8dA7Z@linux.dev>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Wed, 18 Oct 2023 14:35:02 +0200
Message-ID: <87mswgcdmx.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Tue, Oct 17 2023, Oliver Upton <oliver.upton@linux.dev> wrote:

> On Mon, Oct 16, 2023 at 05:30:06PM +0200, Cornelia Huck wrote:
>> On Wed, Oct 11 2023, Oliver Upton <oliver.upton@linux.dev> wrote:
>> 
>> > From: Jing Zhang <jingzhangos@google.com>
>> >
>> > Add tests to verify setting ID registers from userspace is handled
>> > correctly by KVM. Also add a test case to use ioctl
>> > KVM_ARM_GET_REG_WRITABLE_MASKS to get writable masks.
>> >
>> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
>> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>> > ---
>> >  tools/testing/selftests/kvm/Makefile          |   1 +
>> >  .../selftests/kvm/aarch64/set_id_regs.c       | 479 ++++++++++++++++++
>> >  2 files changed, 480 insertions(+)
>> >  create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c
>> 
>> (...)
>> 
>> > +static void test_user_set_reg(struct kvm_vcpu *vcpu, bool aarch64_only)
>> > +{
>> > +	uint64_t masks[KVM_ARM_FEATURE_ID_RANGE_SIZE];
>> > +	struct reg_mask_range range = {
>> > +		.addr = (__u64)masks,
>> > +	};
>> > +	int ret;
>> > +
>> > +	/* KVM should return error when reserved field is not zero */
>> > +	range.reserved[0] = 1;
>> > +	ret = __vm_ioctl(vcpu->vm, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);
>> > +	TEST_ASSERT(ret, "KVM doesn't check invalid parameters.");
>> 
>> I think the code should first check for
>> KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES -- newer kselftests are supposed
>> to be able to run on older kernels, and we should just skip all of this
>> if the API isn't there.
>
> Ah, thanks! I'll apply the following on top:
>
> diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> index 5c0718fd1705..bac05210b539 100644
> --- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> @@ -452,6 +452,8 @@ int main(void)
>  	uint64_t val, el0;
>  	int ftr_cnt;
>  
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES));
> +
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>  
>  	/* Check for AARCH64 only system */

Thanks, LGTM.

