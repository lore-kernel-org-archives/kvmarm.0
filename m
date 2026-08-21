Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8817643F8D4
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 11:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787311589; cv=none; b=P6/2BaNoAhew6GDiL6MvEOTMB+bY8/KNwOAh7FDirFVrr9bVXOOUNxuQC8XXxz6ef1fWAMTo4qGmDuGn5ZYsgEzxJCTNO/VagDXCEq1PTIbDREqqRV4ExD2gou2qi0HtXhxxQTKvGTuT4ywiigxdypTPtup7DpolnY+MenAMqnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787311589; c=relaxed/simple;
	bh=Bl+hTE7mLTOt5f/k2vBFWuhv1+9Osdu/Tt7Pkm/CsuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=OJXRTc46/tzxhTPJnGGJPxi76M3J4qystkSZwEVN8pjtAEMfsalcYGMU+1sOUxDIDFBfWILcyL80XlgOu6vEipNn99tvdMMG4VhITQSEahQ+irM1H3ypmQ+niiAWWByKYeGGum1JSuEKHYTDsq/Ps1wmhPg0syJzuSxtpDAhEWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SzGA+SkJ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SzGA+SkJ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19B851596;
	Fri, 21 Aug 2026 04:26:20 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D6653F763;
	Fri, 21 Aug 2026 04:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787311583; bh=Bl+hTE7mLTOt5f/k2vBFWuhv1+9Osdu/Tt7Pkm/CsuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SzGA+SkJNd0Je+3zKJAyGf1m9WfOuDAW1oZfaMXZJEigu/ojNzVCJHcA443IIKDEN
	 94WQTAooNVv3FwPmJpVT6tSwVoUgDyIjAxV2ORk9c/0SHMm44bXbr01TpGfFClX2wk
	 ZqwP8TnJllBLq1SWPM40aYbbwTiiNV4WFktXp/8Q=
From: Leonardo Bras <leo.bras@arm.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Mark Brown <broonie@kernel.org>,
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
Date: Fri, 21 Aug 2026 12:26:13 +0100
Message-ID: <aog11Xfjf-tmA4PO@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <hwz52absjxap7n6olwt3lmjakmtgxxaku5gcofsrcfa45zdygh@dqgylcillnud>
References: <aoXamcdKoMynTkpX@LeoBrasDK> <48be9e5d-357a-4863-8682-8b3f34c69723@sirena.org.uk> <aobUGyq8nInJYkdA@LeoBrasDK> <97ad6e83-b22b-4881-b644-66fa99f68d64@sirena.org.uk> <aocOi3wjcliZqoe7@LeoBrasDK> <hwz52absjxap7n6olwt3lmjakmtgxxaku5gcofsrcfa45zdygh@dqgylcillnud>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Aug 21, 2026 at 12:39:08AM +0100, Wei-Lin Chang wrote:
> On Thu, Aug 20, 2026 at 03:28:39PM +0100, Leonardo Bras wrote:
> > On Thu, Aug 20, 2026 at 03:07:14PM +0100, Mark Brown wrote:
> > > On Thu, Aug 20, 2026 at 11:16:59AM +0100, Leonardo Bras wrote:
> > > > On Wed, Aug 19, 2026 at 05:46:00PM +0100, Mark Brown wrote:
> > > 
> > > > > This is just because there isn't a preexisting ctxt_has_tcrx() check
> > > > > already there, FEAT_GCS architecturally depends on FEAT_TCRX and there
> > > > > was a request to make this explicit in the code to try to optimise
> > > > > things a bit.  The compiler should skip over both blocks at once if TCRX
> > > > > isn't there rather than having two separate tests or static branches.  I
> > > > > didn't add new checks where there were none since I expect that to be
> > > > > unhelpful for code generation, you'd get the reverse situation and emit
> > > > > two checks.
> > > 
> > > > Humm, but then why saving GCSPR_EL2 does not depend on TCRX/E2H? Or maybe a 
> > > > better question, why are not GCSPR_EL2 and GCSCR_EL2 saved in the same 'if' 
> > > > clause under ctxt_has_tcrx() (and E2H set), if they are restored in the 
> > > > same 'if' clause?
> > > 
> > > > As you mentioned, GCS depends on TCRX, so it should be fine, but just by 
> > > > reading the code I see:
> > > > - GCSCR_EL2 :
> > > > 	Save if 	GCS=1, TCRX=1, E2H=1
> > > > 	Restore if 	GCS=1, TCRX=1
> > > > - GCSPR_EL2 :
> > > > 	Save if 	GCS=1,
> > > > 	Restore if	GCS=1, TCRX=1
> > > 
> > > > Which looks kind of confusing for the as a first time reader.
> > > 
> > > > Does it make sense?
> > > 
> > > I agree that the current situation is a bit hard to follow, I'd actually
> > > originally written things without the explict dependency because of that
> > > but Marc wanted the optimisation.
> > 
> > Well, I am not against the explicit dependency thing, it just looks odd 
> > to me that some save/restore have a dependency and it's counterpart does 
> > not. As well as the dependencies for both registers being different.
> 
> Hey I feel the question wasn't answered completely :)
> 
> Here is the reason for the asymmetric save restore (besides the tcr2
> part):
> 
> GCSCR
>  If guest E2H == 1:
>  - L1 accesses to GCSCR_EL2 and GCSCR_EL1 have the same intent -> they
>    both mean access the vCPU GCSCR_EL2.
>  - L1 access to GCSCR_EL2 (e.g. msr GCSCR_EL2, x0) traps, KVM updates
>    both the in-memory vCPU GCSCR_EL2, and the hardware GCSCR_EL1 for the
>    the guest. In-memory copy stays up to date.
>  - L1 access to GCSCR_EL1 does not trap -> in-memory vCPU GCSCR_EL2
>    becomes stale if it's a write.
>  - From above, must save on exit.
> 
>  If guest E2H == 0:
>  - Only L1 accesses to GCSCR_EL2 mean access the vCPU GCSCR_EL2.
>  - L1 accesses to GCSCR_EL2 always traps.
>  - In-memory vCPU GCSCR_EL2 always stay up to date.
>  - From above, no need to save on exit.
> 
> GCSPR
>  - Regardless of the guest E2H value, hardware could write to the
>    hardware GCSPR_EL1, making the in-memory vCPU GCSPR_EL2 stale.
>  - From above, must save on exit.
> 
> Restore is trivial, vCPU GCSCR_EL2/GCSPR_EL2 must be written to the
> hardware EL1 registers because someone else could be using it.
> 
> Quite a few other registers are saved only if guest E2H == 1 because of
> the same reason.
>

Ah, makes sense.
Thanks Wei-Lin!
