Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0BB3413793
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 10:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787221042; cv=none; b=mIzZWtMJTpRi3rRNYJ6cf0RAghZaepCiSPGoWWHWI9K36aawdd8oLAj0rQNhfLwO0KqDt4Wva7JrOwOnqS+iWOH7se12ncfZI9gOnHGuaMNmtYSVAhbugudwGm57CBM/Q3sOsMGwk+ynrMeAqTKto0v+8DWsqSS3E9oI5qQ8SkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787221042; c=relaxed/simple;
	bh=+7Rmuor6yXuOnxCcupVMz2jDFYfkI0A5Czu3oK9FVYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=SfMa9ETZQrjLemCxZ94VovA95xqy5IU/05PfoC1nthSGDiACH/gtjFk25vr8g6MqjAcnbSslKrmLrlMbDOzd7MKB/fa9tcpzMvAZHznbjmksA+rZqynUaUHh2cn5i33M/Kk0u6lL2hSiQhzZdmeA06kj1ky6NIy01O69CIktWjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XD6tLs3/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XD6tLs3/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56DED14BF;
	Thu, 20 Aug 2026 03:17:06 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AFEF23F66F;
	Thu, 20 Aug 2026 03:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787221030; bh=+7Rmuor6yXuOnxCcupVMz2jDFYfkI0A5Czu3oK9FVYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XD6tLs3/X7CDnMBm6Imqu8tx5lVQFY+S7OnbaDHQ1Or87h9W5tjb5+JvyI1wvWFj7
	 BPAWPekKQcovoaTpdRukZSwxKw9epksB57CaQwwdwAeXYQOp+8rPB0gzIsv1y1Ng8M
	 zFuRGVBbNYqOFafJlJH9wA4RMmBY5Zb3CT1+TBgQ=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 03/14] KVM: arm64: Manage GCS access and registers for guests
Date: Thu, 20 Aug 2026 11:16:59 +0100
Message-ID: <aobUGyq8nInJYkdA@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <48be9e5d-357a-4863-8682-8b3f34c69723@sirena.org.uk>
References: <aoXamcdKoMynTkpX@LeoBrasDK> <48be9e5d-357a-4863-8682-8b3f34c69723@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Aug 19, 2026 at 05:46:00PM +0100, Mark Brown wrote:
> On Wed, Aug 19, 2026 at 05:32:25PM +0100, Leonardo Bras wrote:
> > On Wed, Aug 12, 2026 at 08:12:02PM +0100, Mark Brown wrote:
> 
> > > In order to allow guests to use GCS we also need to configure
> > > HCRX_EL2.GCSEn, if this is not set GCS instructions will be noops and
> > > CHKFEAT will report GCS as disabled.
> 
> > It is zero on reset, and keeping it in zero disables GCS in EL0&EL1, so 
> > unless we are in EL2&0 (HCR_EL2.{E2H, TGE} is {1, 1}), we need to enable it 
> > so EL1&0 (guests) can have access to it.
> 
> Right.
> 
> > > @@ -77,6 +80,8 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
> > >  	__vcpu_assign_sys_reg(vcpu, SP_EL2,	 read_sysreg(sp_el1));
> > >  	__vcpu_assign_sys_reg(vcpu, ELR_EL2,	 read_sysreg_el1(SYS_ELR));
> > >  	__vcpu_assign_sys_reg(vcpu, SPSR_EL2,	 read_sysreg_el1(SYS_SPSR));
> > > +	if (ctxt_has_gcs(&vcpu->arch.ctxt))
> > > +		__vcpu_assign_sys_reg(vcpu, GCSPR_EL2, read_sysreg_el1(SYS_GCSPR));
> 
> > Out of curiosity here,
> > Why does the saving of GCSCR_EL2 depends on ctxt_has_tcrx() (and E2H set), 
> > and saving SYS_GCSPR does not? ... 
> 
> This is just because there isn't a preexisting ctxt_has_tcrx() check
> already there, FEAT_GCS architecturally depends on FEAT_TCRX and there
> was a request to make this explicit in the code to try to optimise
> things a bit.  The compiler should skip over both blocks at once if TCRX
> isn't there rather than having two separate tests or static branches.  I
> didn't add new checks where there were none since I expect that to be
> unhelpful for code generation, you'd get the reverse situation and emit
> two checks.

Humm, but then why saving GCSPR_EL2 does not depend on TCRX/E2H? Or maybe a 
better question, why are not GCSPR_EL2 and GCSCR_EL2 saved in the same 'if' 
clause under ctxt_has_tcrx() (and E2H set), if they are restored in the 
same 'if' clause?

As you mentioned, GCS depends on TCRX, so it should be fine, but just by 
reading the code I see:
- GCSCR_EL2 :
	Save if 	GCS=1, TCRX=1, E2H=1
	Restore if 	GCS=1, TCRX=1
- GCSPR_EL2 :
	Save if 	GCS=1,
	Restore if	GCS=1, TCRX=1

Which looks kind of confusing for the as a first time reader.

Does it make sense?

Thanks!
Leo
