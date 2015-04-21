From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: Re: [PATCH v2 06/10] KVM: arm64: guest debug,
 add SW break point support
Date: Tue, 21 Apr 2015 22:42:45 +0800
Message-ID: <CADt_bzh=zhSmoQnKxp5cUski3S=riYG5AnmCsm=qeTSjm=cprA@mail.gmail.com>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-7-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4082307845926095484=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 437F04D566
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2015 10:34:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aiSLM4HPjUIa for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Apr 2015 10:34:45 -0400 (EDT)
Received: from mail-lb0-f171.google.com (mail-lb0-f171.google.com
 [209.85.217.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3277D4D536
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2015 10:34:39 -0400 (EDT)
Received: by lbbuc2 with SMTP id uc2so157382820lbb.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2015 07:42:45 -0700 (PDT)
In-Reply-To: <1427814488-28467-7-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, marc.zyngier@arm.com, jan.kiszka@siemens.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, dahi@linux.vnet.ibm.com, linux-arm-kernel@lists.infradead.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============4082307845926095484==
Content-Type: multipart/alternative; boundary=001a11c37232447dbf05143d0fe1

--001a11c37232447dbf05143d0fe1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 31, 2015 at 04:08:04PM +0100, Alex Benn=C3=A9e wrote:
> This adds support for SW breakpoints inserted by userspace.
>
> We do this by trapping all BKPT exceptions in the
> hypervisor (MDCR_EL2_TDE).

why should we trap all debug exceptions?

The trap for cp14 register r/w seems enough to record relevant
informations to context switch the dbg register while neccessary.

--001a11c37232447dbf05143d0fe1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>On Tue, Mar 31, 2015 at 04:08:04PM +0100, Alex Benn=
=C3=A9e wrote:</div><div>&gt; This adds support for SW breakpoints inserted=
 by userspace.</div><div>&gt;</div><div>&gt; We do this by trapping all BKP=
T exceptions in the</div><div>&gt; hypervisor (MDCR_EL2_TDE).</div><div><br=
></div><div>why should we trap all debug exceptions?</div><div><br></div><d=
iv>The trap for cp14 register r/w seems enough to record relevant=C2=A0</di=
v><div>informations to context switch the dbg register while neccessary.</d=
iv><div><br></div></div>

--001a11c37232447dbf05143d0fe1--

--===============4082307845926095484==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4082307845926095484==--
