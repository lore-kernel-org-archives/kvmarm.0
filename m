Received: from mta0.migadu.com (out-121.mta0.migadu.com [91.218.175.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100E44FE2E1
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 07:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790061027; cv=none; b=jTKV+RUGiLWQRtsORJtx7sBpJg+dNxjYE7NGoHjOmao3dwvY4yFNLs0EB5CvFhMKFK5268h+R1jT/CtlM9s6ykc7mWQjWBD/hCoM1pCN932taLSw08IYGAQry6EH3n82/wUa2K29wjsDAHIZEuLHHdshGeADHDRP6gPLFj/wo4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790061027; c=relaxed/simple;
	bh=3MK+mM+3TL+vIpJDgBfEo1/4CmjZ/g4CLaacnDtPy8g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bj59frE6P5l0iPXMl+Z4+HP+8v6/7JVK382Pr61nIClWVWuH3SMQ262JUtOXX89M09sUVBtvkkEB4ODLSafWU1l0YF1rv0YU4uKDW7eWoLgkzzkyNsL+t1TCAJdz4VzPArkwEijxfcXS+/4sSxk6z+LcbMvfx7tQ6/MZqm15hU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vkxuVSTi; arc=none smtp.client-ip=91.218.175.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vkxuVSTi"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=3MK+mM+3TL+vIpJDgBfEo1/4CmjZ/g4CLaacnDtPy8g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790061021; v=1; x=1790665821;
 b=vkxuVSTil4afT2c7Go//Xr/Iah+NABcWEL4VGtVCyOUCUFQGo3ZeWCfXYGwn9LA13z1oh3Co
 0kTDqS3UyyL+tixiq1A53sBJiUPFPRoowBlx1oLk6NZKnQlIRNJLcaaOoRumkCFy2Wk9LLuFOn1
 pK7SPk/VN3vA3vzj+xiY0wzY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d174f1e6b2de58e0;
	Tue, 22 Sep 2026 07:10:21 +0000
X-Mizu-Trace-ID: d174f1e6b2de58e0
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b8c42da963so4171e87.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 00:10:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxxTvU4hEOHywkYKJFt843rarJtpdoycJPE7YYuMX9JH0yZJ8izgbOSB7Zw75b/ReMdC1kFEcw=@lists.linux.dev
X-Gm-Message-State: AFuF++lkn92fGRMIjJ8gKgWCXPf94gVliVnDsheGrtWzn3G3d8frdDMl
	NDt5r/gMVacRA1QDUQJ/fz+eW782KkqygpmEr8NUi1t/L7wqLj++YE26Im0i5vGsfbxlKYuhLjm
	50cf0jtcs+SyqIeUKLKmbLChgdffgPVT4off5/H6i
X-Received: by 2002:a05:6512:1394:b0:5b1:ca0b:25d2 with SMTP id
 2adb3069b0e04-5b8d324c0a7mr113236e87.4.1790061019960; Tue, 22 Sep 2026
 00:10:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260902134118.2718200-1-fuad.tabba@linux.dev> <arGRhHgP_izSwW4T@kernel.org>
In-Reply-To: <arGRhHgP_izSwW4T@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 22 Sep 2026 08:09:43 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy5saEDGkP-19n4L19AbSd+ZtjpDVsPABiZkek6D7AN5A@mail.gmail.com>
X-Gm-Features: AclHuK8I6JcWPH-f3J63av1v70AyMxgZAJlJPzSXAdNB-ZOaq8jKoUkgDKbDOTY
Message-ID: <CA+EHjTy5saEDGkP-19n4L19AbSd+ZtjpDVsPABiZkek6D7AN5A@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Fix arm64 sysreg header dependencies
To: Oliver Upton <oupton@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Shuah Khan <shuah@kernel.org>, Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 21 Sept 2026 at 21:20, Oliver Upton <oupton@kernel.org> wrote:
>
> Hey Fuad,
>
> Thanks for the fix here.
>
> On Wed, Sep 02, 2026 at 02:41:18PM +0100, Fuad Tabba wrote:
> > ---
> > Unlike the two existing sysreg-defs.h rules, this one's recipe is a recursive
> > make, so its prerequisites are not the recipe's arguments. They only decide
> > whether to recurse, which is a question tools/arch/arm64/tools/Makefile already
> > answers. An alternative is therefore to drop the two explicit inputs in favour
> > of:
> >
> >       $(GEN_SYSREG_DEFS): FORCE
> >
> > leaving that Makefile as the only place naming the generator's inputs. Both
> > forms regenerate the header and rebuild the dependents in the same invocation,
> > and neither rebuilds anything when nothing changed. I kept the explicit
> > prerequisites so that the recursion stays conditional, but I am happy to respin
> > with FORCE if you would rather.
>
> This might be the better approach at this point. In the unlikely event
> that new dependencies get added to the kernel side of this, I'll give it
> approximately a 0% chance that the author will update this rule :)

I'm on it!
/fuad

>
> Thanks,
> Oliver
