Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792631688;
	b=L+xAgTD1pGCDy5juep0PuUlxRCGKK1T2xmCiKwP0v6QKn/QNB3jJhn4NZui6znhBRvsq
	 v7LCCzinTLtfytTFJAe1ZlcdfVjKGSeP8HzxrM7nw8JwmWXAWWhksvhr8dpxfHJAFjreL
	 PqIzNzpzWTxqbh0htgfd3Qg8IEgP2SovTV2yVb2C0MznNqNl01b9IjpSmkIU8mjUdRoFe
	 z5twOc6KoR4ThV9pMqb7N7nFw1Dx0eKm5ZA0trA3dc0n7dDecb6tsggvln5JE2BJc8PIH
	 DfFaG80S72ayW0N9mFrGMM9ggdShj5Jyy2wZ/Xhe8dTs4XPTZ3KgzOw1I0Wyf+sJYqw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792631688;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=a8oVHE7uhvQM0uF0tb8qagzI2B8K9hhXgyXmbesBuqk=;
	b=imllsom8NpfDIcmqSjbabZviyNoe9Kl6n1d2s70caG8t2tuqlpciWDBVzYhCLbmkwcs2
	 /ekPsakydn31HrVog5XkZ3YC6TA/9ERXyf8wRmisnJcR83BHEPpmLnx305InAZhEqnvSg
	 yko4nQCgn90tjEmLoazLchJQStgzYl6bWjNGfJM3UGmoSilh1GHUQBims4Nc/cYq2prHu
	 YhISXzDWuANExB49oRyKLTYDigx39+vfLpTLL/2gqdGNIDrb7kPE/4ZI73E0Pg5Ry2hoW
	 GDzTVfhdHAJTlYV9YhSe8VtSdrMHvhcG/CE04fH2kxyPkxAIYS9R9R93p+WtbmCuNqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=LYelRfeM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC196606A31E
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 01:14:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC196606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=LYelRfeM
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b1f4d8e09aso1987562a12.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 18:14:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792631686; cv=none;
        d=google.com; s=arc-20260327;
        b=gnAG74cGbDAqvN3dBKAvUprtkLjPx/WdZPwEoSty7dISfy3nyG2QXfJyqOwjUR4t7E
         u9oc3cTerfKWfkerR02TAlKoKlCzhIo23vB5I+7JpUMHU4j6/2rVaFaQLp95crbfHcQc
         XPY9Rv1QBDK+GC9DttM016661nHrlw2ME6beqP0ti8Gx+/QfQFJdhri5DyoXj9RGSZR+
         8mF9gGBmOSIXP39Pb/wiqps0JtqPOyM0Bx83gyyGuemOI8O3NR4dLQgGyz9H6m3PNqli
         yDMoFz/lReZYcaNtOjfXFs1uBDAWpOUh4y++8Oedma3qY2JV4aECJZUWvr5MeG4Y5i2I
         4Z7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a8oVHE7uhvQM0uF0tb8qagzI2B8K9hhXgyXmbesBuqk=;
        fh=OUPjOlGNsYucT6dxRKHEyGS7XW7KSi+DXL0ZLbKO60Y=;
        b=WHcyVL5pfCV6VnxhkdTv81YW37/5H11kT/lVqlfhLyvGowlrQe/v5WLbBiiU6wITnE
         wMcu4hiPLtiMds9RCHzOo9PjCfaTLJC+1mn1Nt2b4491Bb7LeGe4uJ6atZ6iCNx4Cw9D
         XEqbRXQvqDQIOCNyTD7cb6aj2TWY729KzCV4G06TT1XR6DRAKkDJXw7ll1mMYmfKxvl1
         HZLENswBdVJv78agMOJicZniiEyOJu5m10Rs9wxARAijrADsRfvPwd9/haj6ZfP5OWB+
         HefXSGCJWgt/8QX+4zMlm6EZB+ahdIm0UV1uxFeXPQjc+t/tC2NWrqM+BPdmVGdboEYx
         yn9Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792631686; x=1793236486; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a8oVHE7uhvQM0uF0tb8qagzI2B8K9hhXgyXmbesBuqk=;
        b=LYelRfeMfn1VbSyvO+hBg5CgOMbaKmHzM4HOsXFy8P/hMUXzQH3TpROs+QThjicvCl
         XPuCNJbdC9o0P7snRXK+OMp0ct1uU6TJ1fBR8sbP5WlOKI65bVgB8/AD2MCXch9VE4El
         QvqDkSOeDxRuwi3N/WMNdyH9x7D3QNb4KouGii7rYHUlKwH/ZIZ2zQvZt7Vj8suKBW5T
         89lhLL3iWbijKi1PTXiBQ/sYzvLlcEOwbj5UoKlVq/mpwA3qDZpeB74p8WG9OvtwRL5b
         rS11Tw365Uxgn2ovBDW5Wkks5S9TZT4hDxAEVl/i2VVE8YxNpE2ZFncfIzRGwp4vw7E8
         EZXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792631686; x=1793236486;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a8oVHE7uhvQM0uF0tb8qagzI2B8K9hhXgyXmbesBuqk=;
        b=DJrTcLAcz8QIBkXYTbGsn7rMwy8r1G6hD84p7j3OcLvYHybeJ8vTudwsu8GSEy/ZXv
         IubWlfkA4Yd4Tfzz7ZINLWCQv9bgwZnFUPCSPvRy8ksSor7CI5QwiZJd2vxeM82B0t4L
         wW455F6xo+WTN73yTQ+69S9cNOOSzW58YhUJnpS4Gux/ubgFwo39qblxQCM6CRvOWL1e
         pTeLHUSDt51EkhHGfZqcZ+lKCcnCpZI7pGsfrqp537pvhHi773qQHt3/cDiqGLAtQ/Gq
         jdOoGhwiapjuY8GzVPjVv9ofK65msNAmZzanjyIrz4aL1ZOajKMVh7aJQ41wcyvHtEDX
         s5xg==
X-Forwarded-Encrypted: i=1; AKwUvBwzJkJp5OaSgMWk9V9alHjZvJfv9AlFpBesYHHsItOytdQgOZ3GV3hgh5yss0bsoQ3/6tflst8=@lists.linux.dev
X-Gm-Message-State: AFq9FYJFLgWm8Te6hs8hz7UegpDCm719HWYYQZnvRu7niJ7QTKHqRGWq
	5NchEOYEmujmpS+swWE2n89lw3J+plgPFn3jd6wV/9cy/1itwq/Y+czeSKUcYjcGz0uAsMQmRCM
	DEH+0FSzflc5tHuxDsyCuiw78lO7Ek8JDS4vzGwi5ng==
X-Gm-Gg: AYBFou3yWEIU9ZA+keXCmqONfdlavzSo5DFPnkRs4rsKogLWKNlR/CCRXo4SqWiAJp4
	h2FJA9ov4d2Rpx6MHtX1aC0S5rxZit6ULvxsICbdQvrKQAjXj3PMm8ezHXWgiob1rpCHp3WK/q+
	URxZvxyxlIVmEJVAzXBmE8QDRKzLEdX1/sVWbJrRtlQQcXgTBhOkTLpjnmD8iqP9Cs+6osaqaqV
	cePUzhcShDMcystG0Qr+blDGkRZmMYXkcPB94u+f9xJRBcGeJRAQ+9xU23L0sYnlDQpS1n7+sFM
	uRKkHXywomQd1pMN82Mnqu51hwObfcjBmQMBSdFIRwaItXm9FC52UZ8bOwwhZU7J2QrzIyNpdAq
	JQzXon4z8c2GIDOdN3JtMeyZgbzyVzvpou+Y1uuLS+LP/9A0UIAYcl26BF9BH5NTHUJumuGjAx8
	mWD+tOC7ULy08T
X-Received: by 2002:a05:6402:428d:b0:6b1:b5b8:b696 with SMTP id
 4fb4d7f45d1cf-6b408eba0a5mr2764546a12.23.1792631685748; Wed, 21 Oct 2026
 18:14:45 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-3-tarunsahu@google.com>
 <CA+CK2bCnS8wcVDbOymBGeJB6pDUkknOpF22EynbwSV=D5=J4ow@mail.gmail.com> <atlEdhPjlyTPDWmG@google.com>
In-Reply-To: <atlEdhPjlyTPDWmG@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 21:14:09 -0400
X-Gm-Features: AclHuK8ceakYR2BnO2tCnQU3MVfSYSSwRjvSGLmyMHhBXtZBiFnzxvM1Bfsv7Tk
Message-ID: <CA+CK2bAxgtx2gZ-UE2HqwAU8=h9K5RE3xozBs1njgLo1-CaPvA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/4] liveupdate: Select file handler by name in the
 preserve ioctl
To: David Matlack <dmatlack@google.com>
Cc: Tarun Sahu <tarunsahu@google.com>, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 7:02=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-10-21 01:17 PM, Pasha Tatashin wrote:
> > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@google.c=
om> wrote:
> > >
> > > Currently luo_preserve_file() iterates over luo_file_handler_list and
> > > picks the first registered handler whose .can_preserve() callback
> > > returns true. When a subsystem introduces a new, backwards-incompatib=
le
> > > file handler alongside an existing one for the same file type, usersp=
ace
> > > has no way to choose which handler preserves a file descriptor, nor c=
an
> > > the kernel keep the existing rollback-safe handler as the default whi=
le
> > > allowing callers to opt into the new handler.
> >
> > That is not how it will work. If we are in the .can_preserve() call,
> > it means the user has already decided which file handlers to use. We
> > need to do that before any preservation happens; otherwise, we could
> > run into conflicts on FLBs i.e. FH of different version require
> > different FLBs.
> >
> > Therefore, there should be a luoctl call (i.e via a new ioctl to set
> > compatability) that provides the kernel with the specs file of the
> > target kernel we are updating to, allowing the kernel to select the
> > compatible file handlers. Since .can_preserve() is called when the
> > user is already preserving files, the specification must have already
> > been supplied, or the kernel should fall back to using the default
> > (i.e., latest) file handlers.
>
> I don't think that is the right direction. IMO the kernel should not be
> choosing which file handler to use, userspace should be. If userspace
> gets it wrong and chooses a file handler the next kernel does not
> support, that's on them.
>
> The problem with the kernel making a decision about file handlers is
> then userspace does not know what arguments to pass in. We are adding
> custom per-file handler arguments to PRESERVE_FD and RETRIEVE_FD. If the
> kernel is picking which file handler to use, say for a memfd, then
> userspace doesn't know which arguments to pass in.

It is not the kernel deciding on its own which handler to use; it is
the system admin (or host orchestrator) that configures LUO before the
LU process starts, because the sysadmin knows what kernel we are
rebooting into and the LUO specs of that target kernel. Meanwhile, the
process calling PRESERVE_FD (e.g., a VMM) only knows about its own FDs
and should not have to track target kernel serialization versions.

Also, the PRESERVE_FD and RETRIEVE_FD arguments are uABI tied to the
FD type, not to a specific internal handler version. They are stable,
and we can expand them the same way any ioctl argument is expanded
(via size and flags), without ever shrinking or breaking them. We
should not play the game of providing completely different uABI
argument structs for different versions of a file handler. If a caller
passes a new feature in the uABI args that the currently configured
file handler version does not support, PRESERVE_FD simply returns
-EOPNOTSUPP, just like any other extensible ioctl.

> Sure you could add some method where userspace could query which file
> handlers are active and decide arguments based on that. But it feels
> backwards.
>
> I think a much cleaner solution is that userspace chooses file handler
> during PRESERVE_FD. I would even require it for RETRIEVE_FD so that we
> are guaranteed that the args the user is passing in are being sent to
> the right file handler. Passing to RETRIEVE_FD also opens the door to
> transforming across Live Update (similar to how AWS did LU from Xen to
> KVM as discussed at LPC).

On RETRIEVE_FD, the preserved metadata already identifies what format
was preserved. Validating that the user is passing the right argument
struct only requires checking the compatable string, not selecting a
serialization version on every call. And if we ever want to support
cross-subsystem transformations on retrieve, that is a retrieve-side
conversion capability.

> Regarding FLB conflicts, today we don't support multiple FLBs for the
> same global state, so there is nothing to conflict. Selecting a file
> handler during PRESERVE_FD doesn't change that.
>
> If we ever need to support multiple FLBs for the same global state
> (e.g. an incompatible change to the PCI FLB), we can add an ioctl that
> lets userspace select which FLB to use before preserving any files.
> After that, only file handlers registered with the selected FLB can be
> used to preserve files. PRESERVE_FD with any other file handler fails.
>
> That keeps the FLB decision up front and global, like you want, while
> still letting userspace pick the file handler for each fd. I'd also
> expect this to be rare, since FLB serialized state can use the same
> feature flags as everything else in this series.

Userspace owns FDs, not FLBs. Whether a subsystem uses one FLB, two
FLBs, or no FLB to coordinate state across FDs is internal kernel
plumbing. Exposing an ioctl for userspace to select FLBs leaks kernel
internals into the uABI.

Therefore, I think we should not select FLBs from userspace at all.
FLBs are an internal kernel mechanism for sharing state across FDs;
from userspace, we only preserve FDs, so that is what should be
configurable, and the kernel should resolve the dependencies and pick
the FLB versions accordingly.

Changing one file handler may require changing another file handler
because they share an FLB. We can't have a situation where one VMM
preserves using FH_A and another uses FH_B for the same FD type,
trying to use different FLBs for the same data (since we can't
preserve the same page into KHO twice). More generally, we are
rebooting the host into a single target kernel, so compatibility is a
session-level property, not a per-FD property. If we need an upfront
global ioctl anyway, configuring the target compatibility upfront in
one place is much cleaner than exposing FLBs to userspace and
splitting version selection between a global ioctl and per-FD
PRESERVE_FD calls.
