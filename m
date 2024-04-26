Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6558516D301;
	Fri, 26 Apr 2024 17:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714154280; cv=none; b=o+AK94noU0q4dJSjcWY6ftI9iF5qh9HdU2Ak9G6GMm8sv3Dh+aM1pOwNVbxJ/s7CEqDijtPuZUqns3vTCohs3KYs5e6ytGZJKFKecuv359xTmtxNTU6pCHpKH0k0fyQ6BIlW58QrKXn3IuPZ2yYK5upVSLZYY8FHbVL0GIrVlx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714154280; c=relaxed/simple;
	bh=2IM2cRKwdKO2bVarr0CwDTsiEpVhv3fQl7E/3JfvaJc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A/iS+C05R11u/Fe8vizHHuVrRiiXpcA4NJSdS5/GV4xB2LS1vlhuwefAbkO3F48HB9pqZYqCo8Iq1tXV/phMyYymZP+upr11AFwEyQ61iTl88ShEaQq0tC2L0UDRHQU6Fo2/HnhjXCE1OP6/MvTcLy5unI5Iqb1FmP4rpOtbWXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0pikr3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0pikr3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B236C4AF07;
	Fri, 26 Apr 2024 17:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714154280;
	bh=2IM2cRKwdKO2bVarr0CwDTsiEpVhv3fQl7E/3JfvaJc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=E0pikr3h+3xyCdPTG3vyrE9mpCBWsH9W/hUZm0Bl5lqAkRaKa6hFvcQoQWfobOVFb
	 qEJ5qfrackQ43c6U3qJxr8fIfJ3ULRDnReDhdgZuOSzPPalYpsjb/4glrENNmUCn7i
	 c9e84yi4CzY/mITinqcPFAzk1jKoFdgXr9FANNrMJLyN5W4nQNpDyMUw42MgHXZM1u
	 gW7j4927n7qn1isIExwlVNvFGdtw9AUoU7CAI+bVNFv1XDAcFdzXmtoo4LdEckEOsp
	 qsJuZyJX1TEUtxqDQevBjePj+jzzZTqBFDvI+aIquqqdaygDOFbGkG4yqLzlFmK9iS
	 JQX+a5HfwrvUQ==
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5acdbfa7a45so663550eaf.2;
        Fri, 26 Apr 2024 10:58:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXN3rjEcjemf/upx3XVWUptlxNJPUp8RnOLiwu/wmFkFj8yABsSJfDq6MAKu9Vm+Z1v+XLIOVmWKkyHxdMkncLbwij7HKOhwoDm88gj+ffe3SRrYhZ04qSEadJcCxrQxQg4
X-Gm-Message-State: AOJu0YwUTAZxs0slKv1G543FH/IxRHbfrOiPuMxXWF78uJ4g+S0AZ+bA
	0EQv5PsQI5epDEbmVhIdL3Gl5Ua94KDjRErKVuOofmU8jVgGot/RkDtVlvSbAze4QW+J4NWtcZG
	D/N3bLAyrnV91IOmRXA2eV42RQ4U=
X-Google-Smtp-Source: AGHT+IGWYMCnRaaRO7gpbtmlDIkklC10XBDO7hblPAYERJTQUsaMQGsGXow68CH3GyyloVT8wKQ2HH/eGiBSFl2gxBA=
X-Received: by 2002:a05:6870:781a:b0:229:e46d:763a with SMTP id
 hb26-20020a056870781a00b00229e46d763amr3985452oab.0.1714154279291; Fri, 26
 Apr 2024 10:57:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240426135126.12802-1-Jonathan.Cameron@huawei.com>
 <20240426135126.12802-2-Jonathan.Cameron@huawei.com> <6347020E-CB49-44ED-87B2-3BB2AA2F59E0@oracle.com>
 <2E688E98-F57F-444F-B326-5206FB6F5C1E@oracle.com> <20240426184949.0000506d@Huawei.com>
In-Reply-To: <20240426184949.0000506d@Huawei.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 26 Apr 2024 19:57:48 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0hBCM0a4DiK1fCnK1QCk3ABykXJQ8p-ZB5qJAh8yf5HhA@mail.gmail.com>
Message-ID: <CAJZ5v0hBCM0a4DiK1fCnK1QCk3ABykXJQ8p-ZB5qJAh8yf5HhA@mail.gmail.com>
Subject: Re: [PATCH v8 01/16] ACPI: processor: Simplify initial onlining to
 use same path for cold and hotplug
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Miguel Luis <miguel.luis@oracle.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Peter Zijlstra <peterz@infradead.org>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, 
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "x86@kernel.org" <x86@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	James Morse <james.morse@arm.com>, Salil Mehta <salil.mehta@huawei.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Hanjun Guo <guohanjun@huawei.com>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "linuxarm@huawei.com" <linuxarm@huawei.com>, 
	"justin.he@arm.com" <justin.he@arm.com>, "jianyong.wu@arm.com" <jianyong.wu@arm.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 26, 2024 at 7:49=E2=80=AFPM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Fri, 26 Apr 2024 17:21:41 +0000
> Miguel Luis <miguel.luis@oracle.com> wrote:
>
> > Hi Jonathan,
> >
> > > On 26 Apr 2024, at 16:05, Miguel Luis <miguel.luis@oracle.com> wrote:
> > >
> > >
> > >
> > >> On 26 Apr 2024, at 13:51, Jonathan Cameron <Jonathan.Cameron@huawei.=
com> wrote:
> > >>
> > >> Separate code paths, combined with a flag set in acpi_processor.c to
> > >> indicate a struct acpi_processor was for a hotplugged CPU ensured th=
at
> > >> per CPU data was only set up the first time that a CPU was initializ=
ed.
> > >> This appears to be unnecessary as the paths can be combined by letti=
ng
> > >> the online logic also handle any CPUs online at the time of driver l=
oad.
> > >>
> > >> Motivation for this change, beyond simplification, is that ARM64
> > >> virtual CPU HP uses the same code paths for hotplug and cold path in
> > >> acpi_processor.c so had no easy way to set the flag for hotplug only=
.
> > >> Removing this necessity will enable ARM64 vCPU HP to reuse the exist=
ing
> > >> code paths.
> > >>
> > >> Leave noisy pr_info() in place but update it to not state the CPU
> > >> was hotplugged.
> >
> > On a second thought, do we want to keep it? Can't we just assume that n=
o
> > news is good news while keeping the warn right after __acpi_processor_s=
tart ?
>
> Good question - my inclination was to keep this in place for now as remov=
ing
> it would remove a source of information people may expect on x86 hotplug.
>
> Then maybe propose dropping it as overly noisy kernel as a follow up
> patch after this series is merged.  Felt like a potential rat hole I didn=
't
> want to go down if I could avoid it.
>
> If any x86 experts want to shout that no one cares then I'll happily drop
> the print.

You can do that I think and see if anyone complains.  I'm not really
expecting this to happen, though.
