Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FD630D05
	for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 15:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=YM4Qm3Hjr43Eqs/2gEOwZxrCqRXSp+DHKQuuGty2fNI=; b=bPOBzXeaI99AVk+FxpWlXw8wMB
	YcuXW1WXJd7KPglVafC5Z+4bGTeSOPW3ivDpEn0litHriJna6hKkSbOx7PxtKyTMi53Y/7JVRMXgf
	x1isLkESjbYkFG4i4LQgrCa1kUJ0Tz+KQm4ymFstoUfcnBPSX7jIeoZ/Bc01mb92MaAHlIwju+kW7
	lrmzPOmHJOg+gXCGmdbWtwdRsiq7dlmyeIwUthH6kMtuSqqV1WqZOqEKR1mXsUINdo9UKIGfy3DO2
	SKKxo6tn8uRImno7L711uvBgdvoMo/unQGmNRzdzt847k3m1KNUzpDkduPItu+RT6fezfGxcy2fWl
	c0Bf6xYA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53852)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qhAwT-0005nZ-0y;
	Fri, 15 Sep 2023 16:41:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qhAwT-0005v3-Cm; Fri, 15 Sep 2023 16:41:13 +0100
Date: Fri, 15 Sep 2023 16:41:13 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Salil Mehta <salil.mehta@huawei.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	James Morse <james.morse@arm.com>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"x86@kernel.org" <x86@kernel.org>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	"jianyong.wu@arm.com" <jianyong.wu@arm.com>,
	"justin.he@arm.com" <justin.he@arm.com>
Subject: Re: [RFC PATCH v2 27/35] ACPICA: Add new MADT GICC flags fields
 [code first?]
Message-ID: <ZQR7GY1Z57wK8RaX@shell.armlinux.org.uk>
References: <20230913163823.7880-28-james.morse@arm.com>
 <CAMj1kXHRAt7ecB9p_dm3MjDL5wZkAsVh30hMY2SV_XUe=bm6Vg@mail.gmail.com>
 <20230914155459.00002dba@Huawei.com>
 <CAMj1kXFquiLGCMow3iujHUU4GBZx2t9KfKy1R9iqjBFjY+acaA@mail.gmail.com>
 <f5d9beea95e149ab89364dcdb0f8bf69@huawei.com>
 <ZQQDJT6MOaIOPmq5@shell.armlinux.org.uk>
 <CAJZ5v0jUQ+4G5ArYAtu1gvYF4356CK_QVTO4oWn0ukwdOiZaHA@mail.gmail.com>
 <80e36ff513504a0382a1cbce83e42295@huawei.com>
 <ZQRfaYYwrYQEfICN@shell.armlinux.org.uk>
 <9e327ad1128045fa80eebf327abaa8f0@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e327ad1128045fa80eebf327abaa8f0@huawei.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Fri, Sep 15, 2023 at 03:17:21PM +0000, Salil Mehta wrote:
> Hi Russel,
> Thanks for highlighting your concerns.
> 
> > From: Russell King <linux@armlinux.org.uk>
> > Sent: Friday, September 15, 2023 2:43 PM
> > To: Salil Mehta <salil.mehta@huawei.com>
> > Cc: Rafael J. Wysocki <rafael@kernel.org>; Ard Biesheuvel
> > <ardb@kernel.org>; Jonathan Cameron <jonathan.cameron@huawei.com>; James
> > Morse <james.morse@arm.com>; linux-pm@vger.kernel.org;
> > loongarch@lists.linux.dev; linux-acpi@vger.kernel.org; linux-
> > arch@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
> > kernel@lists.infradead.org; linux-riscv@lists.infradead.org;
> > kvmarm@lists.linux.dev; x86@kernel.org; Jean-Philippe Brucker <jean-
> > philippe@linaro.org>; jianyong.wu@arm.com; justin.he@arm.com
> > Subject: Re: [RFC PATCH v2 27/35] ACPICA: Add new MADT GICC flags fields
> > [code first?]
> > 
> > On Fri, Sep 15, 2023 at 09:34:46AM +0000, Salil Mehta wrote:
> > > > > Note that the ACPI spec says enabled + online-capable isn't defined.
> > > > >
> > > > > "The information conveyed by this bit depends on the value of the
> > > > > Enabled bit. If the Enabled bit is set, this bit is reserved and
> > > > > must be zero."
> > > > >
> > > > > So, if x86 is doing something with the enabled && online-capable
> > > > > state (other than ignoring the online-capable) then technically it
> > > > > is doing something that the spec doesn't define
> > > >
> > > > And so it is wrong.
> > >
> > > Or maybe, specification has not been updated yet. code-first?
> > 
> > What is the point in speculating. If you want to speculate about it,
> > fine, but please don't use speculation as a reason that "oh we need
> > to sort this out before we can merge the patches".
> 
> [already replied in other thread but repeating it here]
> 
> Sorry, I am not aware but I was suggesting this. Can we have this
> done for ARM first because there is a legitimate use-case. This
> can be done in parallel while other patches are getting reviewed.
> It would be great if they get accepted even in the current form.
> 
> 
> > This is precisely why engineers are bad at producing products. They
> > like to continually tweak the design, and the design never gets out
> > the door. You need someone who is a project manager to tell engineers
> > when to stop. Without a project manager to do that, eventually the
> > project fades into insignificance because it becomes no longer relevant
> > or has its funding cut.
> > 
> > Hotplug VCPU on aarch64 feels exactly like that - it seems to be an
> > engineer project that is just going to for-ever rumble on and never
> > actually see the light of day.
> 
> 
> Sometimes things are not in single persons control. Yes, it is
> frustrating, I do understand that.
> 
> 
> > So please - stop speculating and lets get vCPU hotplug *actually*
> > delivered and usable. Even if it's not 100% perfect.
> 
> We need to decide what is the criteria of acceptability and it can
> vary across organizations. It depends upon internal requirements.
> The issues what I pointed are,
> 
> 1. Legacy OS will not boot on latest platform with hotplug support.
>    - Try running older windows on ARM platform with hotplug support.
>      - older windows will only see boot cpu with online-capable bit.
>      - Will windows use _OSC to check compatibility?
>    - We have verified this with older Linux and it only shows 1 CPU.
> 2. Hot(un)plug of cold-booted CPUs.  
>    - Its use-case is subjective. Maybe you can throw light on this.
> 
> With current composition of bits both 1 & 2 cannot be supported
> simultaneously. 
> 
> It is perfectly okay to live with them while clearly indicating
> what we intend to support or are in process of supporting it.
> But we do need an open discussion about how to proceed. This is
> to avoid surprises later on.
> 
> BTW, I am just trying to make every one aware of the problems.

Please do it as a separate discussion then - rather than starting a
thread in response to a posting of patches which are _supposed_ to
be being reviewed.

Bringing up issues which are in effect future enhancements without
explicitly stating that they are future enhancements makes it look like
the patch set isn't ready to be merged - and is a distraction to trying
to get the series merged.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
