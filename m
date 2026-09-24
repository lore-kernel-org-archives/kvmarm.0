Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDE533F599;
	Thu, 24 Sep 2026 14:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258929; cv=none; b=l2oRRg+RBGLsxLhDewtor24YcNKzXh+CDCvFkyhbf166jcXU1bSoJ9NZ02Zu1CsyYBeEtIn540p5Hu2E/eb+cehlejZNROnQTAmjvA6RODfVKkLMyXhZDepPt8xQQEnojNOeLeB9sTEcZ32ZPHII17zLEHnaSeu7wnopvYubn/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258929; c=relaxed/simple;
	bh=GtTOHyQXXnDz7lV95xuO452mPKWK/Quc+tZqURSxA4M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PvGjHOY4QcsTnWPu+CyhG4IsPYTRc6dphlGhHPVas5c9aq1xpHF2VNOvrYJVbGAnwV0Z3TIZDVZ+7YdLmH2M8LPN3zXThbHgaTAYADTJjkquymHsMamuyGoDqmccbjY5reB0Y2gxS7US15FmaCgCwhl7SOdNkIjOrvp4pRJV/Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fw34UQ93; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fw34UQ93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA411F000FF;
	Thu, 24 Sep 2026 14:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790258928;
	bh=/oui4jQMtGu5qJSIxw36N2MNjQMxKXaizUrOad25/kY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fw34UQ93vMo4jabb0tJGcabHdKbRBZfWcwCR+q/x+eZchCtLrqwrqJoQ9P0Cp3y7I
	 pcTlha/Fc4L+GOfPDvbmsxjAuiold5fEBbOSLFtJSxuptcK3VavPRdh58jC+80kxJE
	 u3FQosD3cM4TLaWZZAqnGteaFkG3FDkUViwDfdWwTqywQR8BKst3O7RUa82wtXG069
	 iCZKKpMmf/NOlQvnVMdBCF/RtES+3hrgkOBf7/7J6gaJC1EZ2PiG4yQhYyQUlDqeCs
	 wSQnBUxJ7Yxg2OeKST2ETre91Cz6FiJj02T+XOpa5/jcbiTzp4bXa6Cnp68kTZcIzs
	 tt4CX7jSTURPw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 4/7] firmware: arm_rmm: Add support for SRO
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260924135201.850038-5-suzuki.poulose@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-5-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 14:08:47 +0000
Message-Id: <20260924140847.AFA411F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] arm_rmm: SRO cancellation loop prematurely exits, leaving operatio=
ns suspended
--

commit 95084224252b24a8efc8b9db3fa71d3058e8d228
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Add support for SRO
   =20
RMM v2.0 introduces the concept of "Stateful RMI Operations" (SRO). This
commit adds support for executing SROs, including donating and reclaiming
memory dynamically as requested by the RMM. It also implements cancellation
support for these operations.

> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rm=
i.c
> index c9ea964fd9081..035f21d3f26b6 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c

[ ... ]

> +		if (ret) {
> +			/*
> +			 * All memory donating SROs must be cancellable. So a
> +			 * failure in memory allocation shouldn't be an issue.
> +			 * However, if we encounter a random failure (e.g.,
> +			 * buggy RMM), don't loop forever, just give up.
> +			 */
> +			if (WARN_ON_ONCE(!can_cancel))
> +				return ret;
> +			/*
> +			 * If we have already cancelled, and came back here due
> +			 * to an error in MEMREQ, then there is no point
> +			 * in going in loops.
> +			 */
> +			if (WARN_ON_ONCE(cancelled))
> +				break;
> +			rmi_op_cancel(sro_handle, regs);
> +			cancelled =3D true;
> +
> +			if (WARN_ON_ONCE(RMI_RESULT_STATUS(regs->a0) !=3D RMI_INCOMPLETE))
> +				return ret;

[Severity: High]
Does this error path permanently leave the SRO suspended in the RMM?

The commit message notes that after requesting cancellation, the host must
still "continue the operation until it has completed (otherwise the incompl=
ete
operation may cause future RMM operations to fail)".

However, when rmi_op_cancel() issues SMC_RMI_OP_CANCEL, it returns RMI_SUCC=
ESS
to acknowledge the cancel request, overwriting regs->a0. As a result,
RMI_RESULT_STATUS(regs->a0) !=3D RMI_INCOMPLETE evaluates to true, triggeri=
ng
this WARN_ON_ONCE and causing an immediate return. The host fails to issue =
the
required SMC_RMI_OP_CONTINUE calls to drive the cancellation to completion.

> +		}
> +	}
> +
> +	if (cancelled)
> +		return -ECANCELED;
> +
> +	return regs->a0;
> +}
> +EXPORT_SYMBOL_GPL(rmi_sro_memxfer_execute);

[ ... ]

> +long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
> +{
> +	bool cancelled =3D false;
> +	unsigned long sro_handle =3D regs->a1;
> +
> +	rmi_smccc_invoke(regs);
> +
> +	sro_handle =3D regs->a1;
> +	while (RMI_RESULT_STATUS(regs->a0) =3D=3D RMI_INCOMPLETE) {
> +		bool can_cancel =3D RMI_RESULT_CAN_CANCEL(regs->a0) =3D=3D RMI_OP_CAN_=
CANCEL;
> +
> +		switch (RMI_RESULT_MEMREQ(regs->a0)) {
> +		case RMI_OP_MEM_REQ_NONE:
> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
> +					regs);
> +			break;
> +		default:
> +			WARN_ON_ONCE(1);
> +			if (!can_cancel)
> +				return regs->a0;
> +			/*
> +			 * We can't get here normally, but handle this anyway
> +			 * for a buggy RMM implementation.
> +			 */
> +			if (cancelled)
> +				return -ECANCELED;
> +			rmi_op_cancel(sro_handle, regs);
> +			cancelled =3D true;
> +		}
> +	}

[Severity: High]
Does this loop terminate prematurely without continuing the cancelled SRO?

Similar to rmi_sro_memxfer_execute() above, after rmi_op_cancel() updates
regs->a0 to RMI_SUCCESS, the while loop condition
(RMI_RESULT_STATUS(regs->a0) =3D=3D RMI_INCOMPLETE) evaluates to false. The
function exits immediately without calling SMC_RMI_OP_CONTINUE to complete
the cancellation.

> +
> +	if (cancelled)
> +		return -ECANCELED;
> +
> +	return regs->a0;
> +}
> +EXPORT_SYMBOL_GPL(rmi_sro_execute);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924135201.8500=
38-1-suzuki.poulose@arm.com?part=3D4
