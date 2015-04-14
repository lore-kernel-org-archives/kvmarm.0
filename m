From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 09/10] KVM: arm64: trap nested debug register access
Date: Tue, 14 Apr 2015 12:27:03 +0200
Message-ID: <20150414102703.GW6186@cbox>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-10-git-send-email-alex.bennee@linaro.org>
 <20150410123830.GB3227@hawk.usersys.redhat.com>
 <877ftglaqu.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C17E34D009
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 06:19:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G2jP0uYr+sDs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2015 06:19:08 -0400 (EDT)
Received: from mail-lb0-f180.google.com (mail-lb0-f180.google.com
 [209.85.217.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B0654CF59
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 06:19:08 -0400 (EDT)
Received: by lbcga7 with SMTP id ga7so4396709lbc.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 03:26:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <877ftglaqu.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, marc.zyngier@arm.com, jan.kiszka@siemens.com, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 13, 2015 at 08:59:21AM +0100, Alex Benn=E9e wrote:

[...]

> >> +		/* MDSCR_EL1 */
> >> +		if (r->reg =3D=3D MDSCR_EL1) {
> >> +			if (p->is_write)
> >> +				vcpu_debug_saved_reg(vcpu, mdscr_el1) =3D
> >> +					*vcpu_reg(vcpu, p->Rt);
> >> +			else
> >> +				*vcpu_reg(vcpu, p->Rt) =3D
> >> +					vcpu_debug_saved_reg(vcpu, mdscr_el1);
> >
> > With this lines wrapping, {}'s might be nice.
> =

> My natural inclination is to wrap in {}'s but I know the kernel is a fan
> of the single-statement if forms.
> =

It's accepted to use braces for multi-line single statements - and I
prefer it too :)

-Christoffer
