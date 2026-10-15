Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B584A385E
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 12:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792066951; cv=pass; b=nralO6GehrkIfFNAfVnXuuMdfFIUKzZje75beZDrlBsMCYqUUmoEyrXQthQl5pepMN1CnbMWYKqWmb0slMkE5TLrFzRH/rKJIz3HkbicYhSmgipvLJWurSs5iIkhrEVO30A8TTEIXeihjPaxePQpoa5abN0W16WkWgGBwj8xsG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792066951; c=relaxed/simple;
	bh=czshM1QMuMg4+rcsDWkNHMKhG/X/aGc8CBvJ25RdZ1Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PFPPZCMpJwldHzcDWTN6Ol2pBUp9zKntJX7HXfusMEzVXoktxXmeiOQacC/kLDyXCvDbPBcX2tLt3BhWuenFjorOvpgmOdLfGB9s7Edzq1hAAEKBE8SUUFUkjTDUZswciE0JNieVpIvcGthgCX3+rZ2peY7XgPljRTX7wzNaHNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eijOGzAA; arc=pass smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eijOGzAA"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8ac8a2ac52bso54833057b3.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 05:22:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792066949; cv=none;
        d=google.com; s=arc-20260327;
        b=pPH1Xu4+b6d0ZMC9JythDv5tLd5qJEXlk+VhmfMGGE0KP0AiFEGSGewazv1Ga5vXt0
         CpZJJpKFPub09tQWcDs8PtaRDKuHi7+ERcFv2Ewm430xs5UE77XIi+2hI9Clnpa+7e2W
         dNfSQDCZgY2viietaLyg1dB+q+Bg/KvrFSUIM7Kk/KscjgWnwj81KgmZ3Mw7g7gvt3zZ
         l0sLsl3QLGupNHIcPqj0sE6hAa1Ru4ilbWYgHkCsJsEYgq93wsUNifztq3OdAWlE3EyV
         NcE391OmFEUk3pfSCnyT30yrbtGW5hVOdgm+IS4EsyJHEBNytBgsu6UbRZtLB0nUhZj0
         EoVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=U92CGQXLWP/g3pVsOzf+GbrF6oRwn/h4Pu4vLDCB2+g=;
        fh=4w6cZYnnLdvc4J+E+e9RPoDeDgLTlvHdUYVC6PJebQc=;
        b=iHyAEWXrrqkEkXEeEyJwS4sQNnSBzkNcBgScpUslywEXx4DIDPDKnVqOJoNkUBaznV
         60NkGySRbvVTb3M7O/44tuQwDLZ9zFFoyri8xOq7F2PeNfG7fC2Y6HSbxxgKK8TpOC5J
         sNpjWRw3V5M+mom3zXBchre7xzl/A3Aw+9oIKpnxLzfRbwJ5KArwMITzJrqKB3r7aXei
         kX9eqzuf8NcHq80yF0W4jEwvbOBpRGyLb9t1RuS4M6bkvXCUdx6TFypRzt2vkXmWqaR7
         o+L4XWVEYRELrbuUNDbyi6rr2GXoJizxR1mKzAPeRFG6jTiti+fFbjS8wmhLFWyUBK6z
         lccA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1792066949; x=1792671749; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U92CGQXLWP/g3pVsOzf+GbrF6oRwn/h4Pu4vLDCB2+g=;
        b=eijOGzAAHeeCJioydTE5lvdfvReWQvV/zNBCo8viHUEI7hem5bq3+yrmtoZN9oVv8U
         aPBrH1pfx8lMjsHjXVqNvQsfKCzmAaeXJfSdov20TOaH6QyZKRRUuo2nFP2aD9eWsDJT
         6Xydq/7kk+l6xKk9eYOuiBsT4j3zB267LMxrsFaG5+zoX7/r+y6fiBPTtbe+jucbH45w
         04W6dSO13aMB8BCdHhQ3/ENXL8i/K6FHKP+9/wCqjFIclDOQ1uE5ouizJ/1UOlMdsq4u
         GQY2pXDrnIVCmjb1RBJrYlitDKAJJKCpcpESY/uJsYqI5vEzV4zoeh5MOUpZV30TiAUT
         XknQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792066949; x=1792671749;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=U92CGQXLWP/g3pVsOzf+GbrF6oRwn/h4Pu4vLDCB2+g=;
        b=2Tl4irEKVaMYaNEhkFvL7jPTvDV3XfwnY/IBAD/SxgFo3VwzXmoZfOBdLmAYj7d4Yv
         bu3h+dg71ZEDGr4lxSYJrP8GOKGoYKBJUsd80X6G17knrWfe50+coC3Y/XROGNWwUHWj
         qe0lEC0lslMUelGHxEssSyu48/C94R9FQ+nwoQJlKFYklzvEngS6dudqY5fNnUpe6+Z+
         zHYLqp1spP0GZQ8i9Ek7h6dHWhzZMhU4dOtbyG/j8Kr6IaPy+rMjf9WLtasSTHck5MPI
         RjhdXTLewXoohbZd7nPxNuyVn9YAxyDGo4lWvu+UExkC+gkN1IQTmBf0TjnrimT+qT0v
         hWeA==
X-Forwarded-Encrypted: i=1; AKwUvBxCX81nLfkbMJg168iDJeiok161Bf9Uk+61TO7AU92XmkJKg7lqNCZTXbi188q5K9bohUX0Gro=@lists.linux.dev
X-Gm-Message-State: AFq9FYKcEnMwVuFkIWtU/EYBa8+18ZxHIT4cW+Pop1u/g+SpkdDPQHdM
	fWpUrtW0lz7Jk8TtjSbA9ZUYYggC1Y0OWcxJ6r2bOPJjxcW+xV5IV/vaa4m1AMORjyzrKI4ULjf
	hmKQFrDIMXbat+MQX5dyzsTSVps0wdCtGzy5Y6ghSyw==
X-Gm-Gg: AYBFou0coQ5/Ezfr6jsdgm79cyRs6Ie3ja5wMNwLXWbStvg8mlaDjkYKA1GVOl8MJrN
	136G/mN1uMsvM0/TarCFEIx6eweOez2u+jnsnYjothKUNRVQiq+3sx0iHqNcvIRJIezZoVlPju5
	hykd3UuC6OKteDFupq2oeXbWEcK9bHgyvYwvRLswVZe0k1s6QNaDg/E9n1/sYyNcJU426808eTp
	PRYg7Ps3p1cqcmIjDhis6xqED0f2TsNTEE4TVrwrJenh5i2ftoR4R1vqr7CN3RLovcqoha8WZ1/
	p2hxOiR8mekuxGIcmNpPuUKcbmlBh4mPkCAvmUPazd8JJ91Cvs5cx/MK/40rPgLTqAec86ofOIq
	1vPiGQwx5tqotf6tCaxYppLO47Xw3ApPWWWccZ0c=
X-Received: by 2002:a05:690c:9e:b0:8a9:a1e9:2665 with SMTP id
 00721157ae682-8b07d3c4195mr64805667b3.6.1792066949108; Thu, 15 Oct 2026
 05:22:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-15-khushit.shah@nutanix.com> <395b66c9-4173-401b-b469-8972b710aae2@redhat.com>
In-Reply-To: <395b66c9-4173-401b-b469-8972b710aae2@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 15 Oct 2026 13:22:15 +0100
X-Gm-Features: AclHuK8Tght3x1FGlR6vM-L7TqSFJaoIQpJthPwaxOxww4lF0LHqC4u2oGFG92Y
Message-ID: <CAFEAcA8DcLLYJeE_NUKrFTKfYvHp+6YYAmCdZnBfz2AjRNDnzw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 14/25] target/arm: add neoverse-v2-v2 named CPU model
To: eric.auger@redhat.com
Cc: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
	kvmarm@lists.linux.dev, cohuck@redhat.com, richard.henderson@linaro.org, 
	maz@kernel.org, oliver.upton@linux.dev, berrange@redhat.com, 
	abologna@redhat.com, jdenemar@redhat.com, gshan@redhat.com, 
	skolothumtho@nvidia.com, sebott@redhat.com, armbru@redhat.com, 
	philmd@linaro.org, yangjinqian1@huawei.com, shaju.abraham@nutanix.com, 
	mark.caveayland@nutanix.com, ping@khushitshah.com, sandesh.patel@nutanix.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Oct 2026 at 13:13, Eric Auger <eric.auger@redhat.com> wrote:
>
> Hi Khushit,
>
> On 9/21/26 2:32 PM, Khushit Shah wrote:
> > Add a KVM-only named CPU model for Neoverse V2 r0p1 (TRM 102375),
> > inheriting from neoverse-v2-v1 (r0p0).
> >
> > r0p1 only changes MIDR_EL1.Revision and adds FEAT_ECBHB
> > (ID_AA64MMFR1_EL1.ECBHB).

> >  static const ArmNamedCpuModel arm_cpu_models[] = {
> >      {"arm-v9.0-a-v1", NULL, arm_v9_0_a_v1_props},
> >      {"neoverse-v2-v1", "arm-v9.0-a-v1", neoverse_v2_v1_props},
> > +    {"neoverse-v2-v2", "neoverse-v2-v1", neoverse_v2_v2_props},
> nit I would call it directly neoverse-v2-r0p1 and leave the -v<n> suffix
> for potential fixes. Same for r0p0 obviously.

I'm not very enthusiastic about accumulating different CPU models
for all the different rXpY variations that appear. We used to have
a ton of basically identical pxa720 variants and I was glad to be
able to drop those when we deprecated-and-dropped the pxa support.

Is any user actually going to care about the difference between
r0p0 and r0p1 ? In particular pX changes are just hardware
bugfixes that QEMU was unlikely to be modelling in the first place.

thanks
-- PMM
