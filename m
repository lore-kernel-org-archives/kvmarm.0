Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2AF23AB87;
	Tue, 29 Sep 2026 09:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790675860; cv=none; b=C2o5dyOMWIcYycudKp3W/ShkbArDybZaUphCtNylLn/aVb1JRWqkdJNjwS6mjP7KXeSzrPpZfuaz7X9+m75dOUKChMxU8Em9h5z6DQnYFphWMGJWHu4a/rJpdicRKO85lVCwILa49+lP9vhaut3z8imk+e2qhjAhHJzwHuygVnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790675860; c=relaxed/simple;
	bh=d+ZKEwDqXXq3Ti4vG+eDqs4fFJkDtP2g/+xFxH/lmgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MLz9lXbu3nt07gDQaokTeRiMWgzrANDblD00Dx0RAxeBv/OXX12PP9XnQH37BCSsp7CxrrHU4R8cfqlv3l0pYrxNlqGwJACcq0HbIxX0K5YODXL/6jLZFpOVdp8mQhxjjA/iViLiRq0v0A058uP1P+f0P/WO07LNifms84cK6lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fb2WyCyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fb2WyCyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EEC1F00893;
	Tue, 29 Sep 2026 09:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790675858;
	bh=8QDt2eM8KLNzQYvt3HoPDvG4s9lElCOsMyOXh8TJHgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fb2WyCylrbLcaNREN+dUZDyYRwrWTjL83EhF8Ycu4sbI3KNNqSe+lU31se6ItPfX2
	 SLbetG/f7f1hZtKNGPfFQLcGHvjzK1vg8v2UALtSyg2EMYH//chuFdNUshlXWZWVlV
	 n+AuJT8IAZ9UBLrw8+nVqByJUCyGnq+eVH86MT9sUbD29mz9dKKVi6Ypg2nCn170Fi
	 uHsulutxILrJdf9h5FIsakNwk8ac+p5DOQHHqfaYlLcWzZco1gH3ZeSKDhJDKu+Soz
	 kEcRYxYKzlbDxJe6FoNVkzefxQWqEpD72gJWaoyUUEgSH8lJ2C7qf8RHMMuMuVoO0/
	 JQgnLkL7kJ5Lw==
Date: Tue, 29 Sep 2026 10:57:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Peter Maydell <peter.maydell@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] KVM: arm64: selftests: Check ID regs are
 immutable after a failed run
Message-ID: <aruLe0suMqy7J3Os@gremlin>
References: <20260901-kvm-arm64-idreg-final-v3-0-a0ffa06fa872@kernel.org>
 <20260901-kvm-arm64-idreg-final-v3-3-a0ffa06fa872@kernel.org>
 <arp7mig_PrD9Jbc7@gremlin>
 <CA+EHjTxi=BrJYMb5z9QyGd7k_Ty7x5AbMNJinB5i8GT=BD2L_w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxi=BrJYMb5z9QyGd7k_Ty7x5AbMNJinB5i8GT=BD2L_w@mail.gmail.com>

On Mon, Sep 28, 2026 at 05:56:54PM +0100, Fuad Tabba wrote:
> Hi Lorenzo,
>
> On Mon, 28 Sep 2026 15:46:51 +0100, "Lorenzo Stoakes (ARM)"
> <ljs@kernel.org> wrote:
> > On Tue, Sep 01, 2026 at 07:18:50PM +0100, Mark Brown wrote:
> [...]
> > > Assisted-by: Antigravity:gemini-3.1-pro
> >
> > NIT: we changed the rules for the Assisted-by tag, it only needs to be
> > 'Assisted-by: LLM' now. Not a huge big deal but FYI :>)
> >
> > https://docs.kernel.org/process/coding-assistants.html
>
> That tag dates from way back when the format was still
> AGENT_NAME:MODEL_VERSION :)

Ack yeah it's not a big deal :)

>
> [...]
> > > diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> [...]
> > > +static void test_idreg_frozen_after_failed_run(void)
> [...]
> > > +        /* Creating an in-kernel irqchip would change the ID registers too. */
> > > +        if (kvm_supports_vgic_v3()) {
> > > +                r = __kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3);
> > > +                TEST_ASSERT(r < 0 && errno == EBUSY,
> > > +                            "vGIC creation after failed first run: r=%d errno=%d",
> > > +                            r, errno);
> >
> > I guess in general it's making sure - where there should now be finalisation on
> > reg setting that this is actually enforced?
>
> Yes. The test exercises each of the userspace-facing checks that 2/3
> moves to KVM_ARCH_FLAG_ID_REGS_FINAL: set_id_reg(), set_imp_id_reg()
> and kvm_vgic_create().

Great thanks! :)

>
> Thanks,
> /fuad

--
Cheers, Lorenzo
