Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012042.outbound.protection.outlook.com [52.101.66.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EE219F13F
	for <kvmarm@lists.linux.dev>; Thu,  2 Oct 2025 12:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759408187; cv=fail; b=FIn7a2RPLQVIKRp3D/xmoSd6UCU4hbMv+3UXYxTDUj9ACHfq/BWRBKoHsnQ3vNwwz3J+gjHKsarjzsuV1JllDrdh8tzuVLRqbkc55IJ1WZ00JG30TndTuvOkDz2zriP3WE+64M3uAGIxraZLVr4AAyngo2MmGBiUIMd4cOYZA20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759408187; c=relaxed/simple;
	bh=BBuQsxy9LknwP3bQeXPQLdHJQm77c8WCcQ/E11vGqv8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aiJNf9OwYIGsxVRf4v4ilbGIIWpIXe7TOY9KhjcKZvPJGS98JEyGRQ1OHqauw+FzwYqSGbI4Fz9gbmNHEbo7zMrOFigCL76JfFGBtn0mqoWa6dZKAIvuuQxlyg9XTysldmUSKY1mUv1r9ovLvAwnEGJHeFu6RrUXvUoQazUfMus=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com; spf=pass smtp.mailfrom=epam.com; dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b=bZ9mEnfx; arc=fail smtp.client-ip=52.101.66.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epam.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b="bZ9mEnfx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=adM2nZJwf3UTT9Zvg6HbKTrIlrB5VzmuJQSUKzDxEmT/3VGTvxJcmZQznpAzVegrikthhC01UvoUCNxd+5cS60kjeykQzuOlT7uEVaUVtYStOYR8xtOqtY/smIH5aZorUeIveWWj1Tzq6gZX2wFZozc/IlLNcWvwc1rmdwDmCDOLSD9jYnwfIPH4xfsKsfAIjY3FHTbVDvpkbxkrE7ePl1fh+iIb7xhgNMZSDgV5SXZZtnhMyN8cLqFq3efyBZpDEiGO0dPD4l1PMPb3evEMrm1gOPPW0uJmeVCtFeSY3jybhIogACzXLPZ3tas0AHFXCIayjdmxQK1iUGOVA5vdyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvsMQecorWPkKxHJwEcaQzrStlZ9AEpjxtoEyG0ys0o=;
 b=KhNpzS71a8szLnYDfgrXgdRUikxlBlULTLle0TP+69Bx/d2xKKc5Lbqjb09cFWCSO5LKhzgsd22C4DMTEzJD8oFnQH7/rwtWKjFRUoGX8XqSzYbdIrBWNeVJKCiUfGLhF3qGS+ocgEColHct+mg7T1IErnk0OzoefiL5/uBsbJsZkmdyhWe9F+ygmu9ZklZC4hBYqD064XPekN6yAKU33WSX5vcacU9FCOacvxeQZQnoaz9eRLEESMizixYJ0hIunSFK2wQt3v/gJiXN+aS+X39lZNOiapR1HORyCPl5LYSX/JBZrdwOa3INp9ie/8kMuTjhv3ojn8SL3fA5fQww2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvsMQecorWPkKxHJwEcaQzrStlZ9AEpjxtoEyG0ys0o=;
 b=bZ9mEnfxs/oTGXuPeLNoBYG1HkuYAMwqup9X3vyndofXTL/5446d8K5nEQ4PYVAzOisIcIOE9Fvcm1OnOWrjLYrxSn9gW6xcetJBY89DUzTKJElTtJCBcDcAJ7fwidfJ5tdigU5EhJz8mgngIY6PffEmpATFDWC7PgKOmVAmxq2AlYpMFkADnx/QyDDLZJJ8MxTMNfnbWp+W+lZUOI2Z1XBYCnGBrrpyAZAMDuCJH4vEBb988EMfYSczG4AOwySbH4QRGF395FGqZvA+STBCs2ZMuJP7ZSzfdinTwDUL7keJG9ddW/ztaNTbn0Ewg8s1qnoe4QuZFBjyiIwwG+gmdA==
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 (2603:10a6:150:16a::21) by DB9PR03MB7322.eurprd03.prod.outlook.com
 (2603:10a6:10:220::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 12:29:42 +0000
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e]) by GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e%7]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 12:29:42 +0000
From: Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
To: Marc Zyngier <maz@kernel.org>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Dmytro Terletskyi
	<Dmytro_Terletskyi@epam.com>, kvmarm <kvmarm@lists.linux.dev>
Subject: Re: KVM: Nested VGIC emulation leads to infinite IRQ exceptions
Thread-Topic: KVM: Nested VGIC emulation leads to infinite IRQ exceptions
Thread-Index: AQHcMk7Yj++4l3leA0uVFgouU6YiFg==
Date: Thu, 2 Oct 2025 12:29:42 +0000
Message-ID: <873481pjuz.fsf@epam.com>
References: <87bjmrprvq.fsf@epam.com> <86seg3ytk2.wl-maz@kernel.org>
In-Reply-To: <86seg3ytk2.wl-maz@kernel.org> (Marc Zyngier's message of "Wed,
	01 Oct 2025 08:23:09 +0100")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=epam.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1PR03MB10456:EE_|DB9PR03MB7322:EE_
x-ms-office365-filtering-correlation-id: b6b95168-ad73-4a49-a9ba-08de01af5cda
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|42112799006|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?qkZneeL1J2G4k+D4nkUzRW3lCxHS9wuShOvZpUMTSJhjSEvGRhk91Cazl/?=
 =?iso-8859-1?Q?QYYbZHg1IGd6xJ0Yrp5Uvuj0+WRNUwv0erfp6JYDkL0h3GwVz/jHej4oFn?=
 =?iso-8859-1?Q?7XQeqHsztp8+SG2ctrMPw+ezfyaLKjfCOUJKfwzuI1q2Wt07ce8NGlVP1i?=
 =?iso-8859-1?Q?LpoQt36SJeGLKgenlnV5AO243HPzgFYYAsJ65OlcDM61F2FvpEdmPSwTxm?=
 =?iso-8859-1?Q?E1sLv9EMGJdrhk8B+yY1VdZaOq6pT8wD+w1UFxp4n0GhmjdfVF8JKdYbiX?=
 =?iso-8859-1?Q?B8n1xYjNAtSuXmXo7xwZTdyDOIF1fsg96nnDbYko2Jp8BShO0VtyECNFDb?=
 =?iso-8859-1?Q?pXGDkVr1r3iE1X7QQzDh0ti7iyLR0MceZEtCCyAiaLoxJ0GBQZuOKF+iJj?=
 =?iso-8859-1?Q?BPn/lhQJ3DsrO4oyo0wZybkh04gqwQtgE47/26DMqTPoiuGg66YI72l32w?=
 =?iso-8859-1?Q?hPJ74K0SLom7+If6kma4opg4biLw5olntavdAvRtLE87ueHPKIUGcO2tI+?=
 =?iso-8859-1?Q?1HOgkDCe3UWgpHrkxduBGlVZI3sNG6PaV/2+4rXdc81R3x8mqIjeGimHY0?=
 =?iso-8859-1?Q?OrRkzCYfDTnDK3uDtCpQ9KQuxVmyp3s4E/aaEoEBXAaxeCgSid8UwktYQL?=
 =?iso-8859-1?Q?O7YeqnEsM8ukIE5tgwC18WOrGCGqNFmZiOxSNYYZGLtFDroydUH8VPtoEc?=
 =?iso-8859-1?Q?AkrVs041GEha6kPwBYc0KPn9of0qOIQ8eikx4oMqb4m4oUyiymDZn6rNRM?=
 =?iso-8859-1?Q?5AWKoEj2G/da1rRH4ePG7dtAcs0C8eR04L1CFOTOT7W6Konu5ii3mywbIx?=
 =?iso-8859-1?Q?LPG/R0ok3hhCLxHMz3xGkIYwo1ytCRD1wnRyWg62FWoxWZhQvJtULWufWy?=
 =?iso-8859-1?Q?/Lv3fp3WiU7xbJ1w9CU+Cgf8tgMXAdmh9hBjsqG/Hp9lY+7k55hL72Odt6?=
 =?iso-8859-1?Q?ihj9LJeTlAAz+/xZxtVZ5dSz/FAT2LITErVYdIoism3gvlwxpdCImqiOhA?=
 =?iso-8859-1?Q?GSP5vZOV3tWlcT1CBmAViolNLIc4PdrciuuKJibk65uFCwcrYMMORYh9UP?=
 =?iso-8859-1?Q?hUKyvvZUyoPFLfvnQCi3zv4ouwqsOetebaNDN+6RFgEUkHw/SEgUwxafgT?=
 =?iso-8859-1?Q?BIcnq15zEsUiw+qhgcA4fLgsmaoTmLrBG475Dqn+Wmwz6MBpizgrQr/x50?=
 =?iso-8859-1?Q?MF0PSrv56Hqk+/cC/6lkc5VapTC6verM8GLW7G/4bCbXPIyFx9PlLOx1Hz?=
 =?iso-8859-1?Q?t1rSBhl4XAB9+MNoxhwg2byHT9mIhnfdOrPppf8JxAW2smJbtT0T5TAFq8?=
 =?iso-8859-1?Q?+Ql6dODvUtNlI+ErIoqP5dBZF+h6zkjFMbHhIMTRr2dA27XvsEbu+osr2f?=
 =?iso-8859-1?Q?dvfgtJfepGUD5oKARC8+eGdvbgTPTvGS0iU5aTa4A0GWtpYMpdpxvHSXL/?=
 =?iso-8859-1?Q?Qbd+dour0T3OMSLdKZixA/5UJhJ+8cVBZEVByrz9WcAZIWsMDQE5Gaj7cD?=
 =?iso-8859-1?Q?vfvS7/nm9F+xqm6tnRT4Uaky7EDLp7ai5fWUcYQjuRTPli3lvRyPAjZe1b?=
 =?iso-8859-1?Q?r+2UtsS1fJOsme7omoMu/Q1tx5G4?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR03MB10456.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(42112799006)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?+mKhDT3+EyafbsqegBKL4jarhvK9hPr10MZc8gV0Ro8Hku0pNBE+dURFOG?=
 =?iso-8859-1?Q?Un0Kx7QRoZNeRjo6u70bdQwZ3ePF7S6BV/JJo9Lj1EP8cTxNkw6Y+7ufPe?=
 =?iso-8859-1?Q?buv50/L+4T87Idw3cKMwITrVS86dDiJhkGlBb8/8lKp6byZG+8EId/Lcm3?=
 =?iso-8859-1?Q?987vIRJ1RuYdocxFSjtmMDTJ/PZbqBzF9rb0bNRGwKZV/tsSimRSVfr5PG?=
 =?iso-8859-1?Q?yhqIMP9ZD8SBh9/FBSM3RoH/ewVvG9W9Da5oUey7CTXH6FI0mBA0D2IMqd?=
 =?iso-8859-1?Q?Zi+Tn+ko+h4ZURKE6/64eDIAJMUOFSrde540O617CrxsLDEPyyFegtbK+s?=
 =?iso-8859-1?Q?H8OmNa7/MjoeLgB1y3pz6cDMUgi6iiLMBdQe2Z6iMrvwunaq6QexXTY7y2?=
 =?iso-8859-1?Q?2Felasi67ejHeEt/fLEOKBK6WjIXzv2z3YTL++yYqVXC5nO7MtI08LSxXt?=
 =?iso-8859-1?Q?CZBje8EuFg67qeifYKTp+vG6xy2w5gDw7XH2iKB6Heh7PSUDE0QztqF/5i?=
 =?iso-8859-1?Q?na4K79JXV7kGpkcO7zs7ta4f81I8cpvjiY2Px06vG9+lriAGGSWqkA5YH5?=
 =?iso-8859-1?Q?51MEEFQwqP4rXJy7np+LZYUKosvwRoxJXIDY5sRBJkeMcTwV5RakNbhA4I?=
 =?iso-8859-1?Q?b1AHY0hQB1NU+voBK3lkdbRCYFpgB80tdCrvDQlDZJ6+/Eie2Zqk9+0ZbR?=
 =?iso-8859-1?Q?Ll7f9/Xf7fHfAboJyImmanTRvo5CzC9GF6WEvAwowc3haC0u/0o0Fnzyyi?=
 =?iso-8859-1?Q?4kkilTYYy1Rt4KO5WWuUqWImWHE2Vn5ojgrGAf1We8a7foqNShygqb+VCy?=
 =?iso-8859-1?Q?TvufD9R0yaqAmyLWLi5FUqNI6cxxJQ+b4jpMEHiOKrI7IVYtYeY1BiJJXg?=
 =?iso-8859-1?Q?HkQz531YfAbRyQa4irrxhDmG7OZf3vBdecNTIZVViT08B/k+Nde1hKvbIO?=
 =?iso-8859-1?Q?gxbknrGUd9743R21XNkT5OF2lxdCG4/tt0d4GbBipPc7xTO7dRO6aDobIh?=
 =?iso-8859-1?Q?suydFgskcRlBnaGQqYFDkm/DlvYghlrxEUy2waZWNRtZ2pDuLhhWymvTOm?=
 =?iso-8859-1?Q?ZuMkmT5n8W2OuGtM2FtE3SzBYeA0zC+n9V2rUQzRJv38xanzSLceMZcffO?=
 =?iso-8859-1?Q?cADC+hwzv53/piuoebXq1Z1KcrrxMETl1SsHfP4qvN+8MfhCtc5vXmWjDr?=
 =?iso-8859-1?Q?WZjtr3JpXKLQon3FZ2WXf/1nADHUWC4PbnjMHTTJKIkiLaVVwJWrg/69RQ?=
 =?iso-8859-1?Q?8ru1GpKULmV99uqfIq+WptK70LAVWH044d8+XqfscLnDKisETbGFAzU4u6?=
 =?iso-8859-1?Q?8dbugJFIibPgFQem5/0YcknDEmg/lK9QRCXOVsN/TRTUQtPF1ecs6nhG2C?=
 =?iso-8859-1?Q?b8TGhOQAlrDrpfQbs8KUYmkv1WOP3J2pbhyzlUcxoNtqAdqYQPaB48SMPV?=
 =?iso-8859-1?Q?tc5ijz3drhqbCFCpflh+GrI24WOIPMBmM6PsdkWUEFsQV6fd61S9mSO/Un?=
 =?iso-8859-1?Q?L6DyODVw2SBARxPBF5/izPNzv4eEf9NgThBdUG0kJzPvKsVj2z3nqffwsV?=
 =?iso-8859-1?Q?2zLqJuUFADjbCD3lPOePx0+DXDr2dFgKjKsiEUCWxLKrQCUzYTJWqj2ac6?=
 =?iso-8859-1?Q?nGIKvu0XH6HFys7GYRHCtA+gZvqmz25dh4nDVB1VnsFs/l0Ku34wQmtA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR03MB10456.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b95168-ad73-4a49-a9ba-08de01af5cda
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2025 12:29:42.1586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +HmrJa9lYwAsCFDV9ymfsYolF5C+7PPmiOoLpNYYzpt4OEyVzzEJy1Qkj0RiALP4m5JsnB2o8wgnXGJvKSvoKS1f3odg7jH0Uaf+cAn0rXc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7322

Hi Marc,

Marc Zyngier <maz@kernel.org> writes:

> Please use the kvmarm mailing list for KVM related discussions (added
> for your convenience).

Oops, sorry. I missed that MAINTAINERS have 2 "L:" entries.

> On Tue, 30 Sep 2025 22:11:54 +0100,
> Volodymyr Babchuk <Volodymyr_Babchuk@epam.com> wrote:
>>=20
>>=20
>> Hi all,
>>=20
>> We are trying to run Xen as KVM nested hypervisor (again!) and we have
>> encountered strange issue with GIC nested emulation. I am certain that
>> we'll dig to the root cause, but probably someone on the ML will save us
>> a couple of days of debugging by providing with some insights.
>>=20
>> So, setup is following: QEMU 9.2 is running Xen 4.20 with KVM (latest
>> Linux master branch) as accelerator.
>
> 9.2 is an odd choice, specially as it doesn't have any NV support.
> ISTR that 10.1 is the first version to have some NV support, although
> without E2H0 enablement which I expect Xen requires.

Yep, I had to patch QEMU to enable E2H0 (among other things).

>
> Anyway, if you're already running something, then I expect you're
> patched QEMU to death to get there.

You are certainly correct.

[...]

>
> To help you further, I'd need a reproducer. I've asked you more than
> once to provide a way to reproduce your setup, but got no answer. The
> Debian package doesn't boot (it just messes up grub), and I don't have
> the time to learn how to deal with Xen from scratch.

The current setup is quite complex as it involves whole Android build,
so there is no easy setup to share reproducer.

> Until then, you'll have to apply some debugging by yourself.

This is what I and Dmytro are doing. And looks like I found the
problem. I added some more traces and here we go:

Xen wants to return back to vvCPU:

 qemu-system-aar-3378    [085] .....   246.770716: kvm_inject_nested_except=
ion: IRQ: esr_el2 0x0 elr_el2: 0xffffffc0010e5508 spsr_el2: 0x024000c5 (M: =
EL1h) hcr_el2: 807c663f
 qemu-system-aar-3378    [085] .....   246.770716: kvm_get_timer_map: VCPU:=
 1, dv: 2, dp: 3, ev: 1, ep: 0
 qemu-system-aar-3378    [085] .....   246.770716: kvm_timer_update_irq: VC=
PU: 1, IRQ 28, level 0
 qemu-system-aar-3378    [085] .....   246.770716: vgic_update_irq_pending:=
 VCPU: 1, IRQ 28, level: 0
 qemu-system-aar-3378    [085] .....   246.770717: kvm_timer_update_irq: VC=
PU: 1, IRQ 26, level 1


We have pending timer IRQ for Xen

 qemu-system-aar-3378    [085] .....   246.770717: vgic_update_irq_pending:=
 VCPU: 1, IRQ 26, level: 1
 qemu-system-aar-3378    [085] d....   246.770717: kvm_timer_restore_state:=
 CTL: 0x000000 CVAL:              0x0 arch_timer_ctx_index: 2
 qemu-system-aar-3378    [085] d....   246.770717: kvm_timer_restore_state:=
 CTL: 0x000005 CVAL:   0x3e6c59a71a95 arch_timer_ctx_index: 3
 qemu-system-aar-3378    [085] .....   246.770717: kvm_timer_emulate: arch_=
timer_ctx_index: 1 (should_fire: 1)
 qemu-system-aar-3378    [085] .....   246.770718: kvm_timer_emulate: arch_=
timer_ctx_index: 0 (should_fire: 0)
 qemu-system-aar-3378    [085] d....   246.770719: vgic_update_irq_pending:=
 VCPU: 1, IRQ 25, level: 0

But we also have bunch of ACTIVE interrupts which fill all available
LRs:

 qemu-system-aar-3378    [085] d....   246.770720: vgic_populate_lr: VCPU 1=
 lr 0 =3D 90a000000000004f
 qemu-system-aar-3378    [085] d....   246.770720: vgic_populate_lr: VCPU 1=
 lr 1 =3D 90a000000000004e
 qemu-system-aar-3378    [085] d....   246.770720: vgic_populate_lr: VCPU 1=
 lr 2 =3D d0a000000000004a
 qemu-system-aar-3378    [085] d....   246.770720: vgic_populate_lr: VCPU 1=
 lr 3 =3D d0a000000000004b

As all LR entries have ACTIVE bit set, read from IAR1 will produce 1023,
of course. Problem is that Xen itself can't deactivate these 4 IRQs as
they are directed to DomU, so DomU should active them first. But DomU
can't do this as it is never executed.

I am not sure what is the correct fix, but I see two options:

- Prioritize timer IRQs so they always present in LRs
- De-prioritize ACTIVE IRQs so they are inserted into LRs last.

Looks like the second one is better.


--=20
WBR, Volodymyr=
