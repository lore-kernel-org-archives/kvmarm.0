Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A574E332919
	for <kvmarm@lists.linux.dev>; Thu, 18 Dec 2025 10:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766052440; cv=none; b=mj0s4438rK+ynXuQETNN7v8Px7Uvoy5quq3UieXhnc+keeJWEyX52dVYwTBcYnXFQJOFtvtoUSqE5UAtLBNM+rzpjZPlRdEoLR3EoY10nfZ4D7hmF4hYYVWz0MTQM0gpOPh/vY96ddYpuMOBESx+XKADWZqdtCxSOmPqI8Dm1Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766052440; c=relaxed/simple;
	bh=sX5ot0SWvR4uFdPToYaH3vFF1rWp6L6zdPzZr2BQoWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LVoCgHZusPyC90VF2yKW3t13XK+V/1LOsuXwgximTfkVRmwdCiRL119t7c3rgMXw63DAdxwUHW+UJEtWP8vQ0t5iBpwdMqk/Nnewasgwt2rC5EdljSeNEjJgnWF3Zj4eCNem3Y0RrpDAZYFLovJBQVDJpYdq5M9EEEke+RJA7z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=BQbEMJqa; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="BQbEMJqa"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42e2e628f8aso155613f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Dec 2025 02:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1766052437; x=1766657237; darn=lists.linux.dev;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3XTSYsbyxz/KIY73QMVlXMluHU7KeBcQcAPsFtAx27k=;
        b=BQbEMJqajlRvVVD1bfROo31sbJiA333AVDpSa2t098LyzrvBrRfPw84j1de7HQj1Fn
         H6pkaK6zJSZ+mpXl5q9x4dARJvRE+80dSl9Mf0dXzO5nlSrGAkRZ8HSlsa6FToWnkQQd
         Nzwi7TYGaoV6GxSTn9gGnaUsguT4auxM7rCABGSa+CViRrZmqvX78TM9TUC17PQMHcIh
         0CmRB5jamAbrWwctXb/k5201c/Ze3nTg2a0VhVg+33HHvIrnNYOPfKEqFdDT7CiX8+/Q
         X8cSRnvGdxHFmEyoMUmTnpJ2vAD/Nf9DFbyEUzczokf87RbmG6IqjOV+ytfKm2AvCBF/
         hPeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766052437; x=1766657237;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3XTSYsbyxz/KIY73QMVlXMluHU7KeBcQcAPsFtAx27k=;
        b=LdiA4uFPh182m68AN6p43B1n5ln5KylbABQPcMZur3dzhnNRV9v4SEbjWwdaPk54kK
         Jb4pnCUJjW9mf3nBKRNq+CAyo+pSe2Ll+ztBwXiv2N12SBruQv+e1m28INErsS+s7TvZ
         B6e3KMxs7ugUY/iTBCqOhPkRgv8kChoZd55am9Vp34axo0NQpBKiC1uYMrBj05/Wtx1P
         CK4S82X6em7mZ11ZMkrTp4lw0hBF5nFY6fDaxUR/zRRZdh1bTe2d8kcrBhKtbTCbNj4s
         4oX7uAmacyJyBJ/HKu37iQVlH3ilgOm4619VxU2nrhoHyeGHT6Ziz8iIy9UkEcTyBste
         JCrg==
X-Forwarded-Encrypted: i=1; AJvYcCXR14btqgydrKVhYFYZkmQCgct+TA3q7cAf1ltY/AxYimWjGUis3vSm3pWpMqMKi7nyKyi96wo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz90r0549m3S+Te2jDzzdVy0A93Ewu0IF76lLjZsvM4R2q77aNE
	e8lfJUB61UkaMCbpEcIViW3SlOOTfNPHFFp5Bm95koSpV8BxVebeDKgEiFs0/ScAjhA=
X-Gm-Gg: AY/fxX4wpdgkcAGs834X0kD/dI13ylcHOq6gtD7AZ2curQg3jr1jPp1SwAU6cwVP478
	CIgcmstdymczYst/yeSzyt9gapjlZwRv4tguuDx5aOo7lshXTMY93djxiWcMAI8Ev/ouegK0UDc
	2NDF6ZU/m8pqgVPpwXdqa2nj+hNUBvrOwvUKNwMqVb5yI/J0OmiDySeigkFJIPS6c+H7eYN96Aw
	D49MdnyRMH/+4/WiXH5mftXZGDR2jNgtiwWDZhGOLvx54JKseFzspIQfnXv5avXQrhZ3Hpx6PsV
	Wp19F3rFaMKwP3VGKRwMV3Ygawz8Fy5nlaiXGyMZ4JiIHxkR+7OgFTkbcA2UIOvlmThrgARjJ8Q
	6uiTixoPUBrtw1Vij3F5xiAMNi+zu/ah35ME5MQP3ARnPax7bYljonTT1LjqXLiJWrtNyjEIBCu
	KYuEy5wzhKlFaRewDiJV1iIC8riO3rvrK6lu1ljo5l/ajNx2fp4S8Sie1Bz/0Q2ADXuCPK7lXnj
	6DjtEcTq4EP/fx26V+LOn3XtOBkWFNihhX5s7PiG2corBI=
X-Google-Smtp-Source: AGHT+IFYcQZYNoE7IFGpPLaAgvf7Oneyj5Y8t7UvDpSWbX4/UjEfrN/2gkJmtzsovfR1iQr8f9fTfg==
X-Received: by 2002:a05:6000:2888:b0:430:8583:d196 with SMTP id ffacd0b85a97d-4308583d267mr20126634f8f.33.1766052436717;
        Thu, 18 Dec 2025 02:07:16 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324498f965sm4200787f8f.20.2025.12.18.02.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Dec 2025 02:07:16 -0800 (PST)
Message-ID: <769da4d7-0e8c-447a-be6b-1e3ad9a0ae36@grsecurity.net>
Date: Thu, 18 Dec 2025 11:07:14 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Eric Auger <eric.auger@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
 <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
 <aRufV8mPlW3uKMo4@google.com>
 <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net>
 <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
 <3bac29b9-4c49-4e5d-997e-9e4019a2fceb@grsecurity.net>
 <aUNci6Oy1EXXoQuY@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <aUNci6Oy1EXXoQuY@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------u0IehbX85HN0timF1oZrFJU4"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------u0IehbX85HN0timF1oZrFJU4
Content-Type: multipart/mixed; boundary="------------xVM07hl82XkYJQAQxvVwBdAq";
 protected-headers="v1"
From: Mathias Krause <minipli@grsecurity.net>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Eric Auger <eric.auger@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <769da4d7-0e8c-447a-be6b-1e3ad9a0ae36@grsecurity.net>
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
 <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
 <aRufV8mPlW3uKMo4@google.com>
 <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net>
 <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
 <3bac29b9-4c49-4e5d-997e-9e4019a2fceb@grsecurity.net>
 <aUNci6Oy1EXXoQuY@google.com>
In-Reply-To: <aUNci6Oy1EXXoQuY@google.com>

--------------xVM07hl82XkYJQAQxvVwBdAq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Sean,

On 18.12.25 02:44, Sean Christopherson wrote:
> On Fri, Nov 21, 2025, Mathias Krause wrote:
>> On 18.11.25 02:47, Mathias Krause wrote:
>>
>> Finally found it. It's register corruption within both host and guest.=

>> [...]
>=20
> *sigh*
>=20
> I'm not going to type out the first dozen words that escaped my mouth w=
hen
> reading this.  I happen to like my job :-)

Me too, that's why I had to switch tasks to gain back some sanity ;)

> [...]
>> I hacked up something to verify my theory and made 'regs' "per-cpu". I=
t
>> needs quite some code churn and I'm not all that happy with it. IMHO,
>> 'regs' and lots of the other VMX management state should be part of so=
me
>> vcpu struct or something. In fact, struct vmx_test already has a
>> 'guest_regs' but using it won't work, as we need offsetable absolute
>> memory references for the inline ASM in vmx_enter_guest() to work as i=
t
>> cannot make use of register-based memory references at all. (My hack
>> uses a global 'scratch_regs' with mutual exclusion on its usage.)
>=20
> So, much to my chagrin, I started coding away before reading your entir=
e mail
> (I got through the paragraph about 'regs' getting clobbered, and then c=
ame back
> to the rest later; that was a mistake).

A common mistake of mine: writing lengthy explanations that don't get
read. Maybe I should start included some tl;dr section for such cases ;)

> I had the exact same idea about making regs per-CPU, but without the qu=
otes.

Actually, I wanted something quick to test, so I went the easy route and
used a global array. However, my plan for a proper fix was to do the
real per-cpu thing, as that would still fit the "offsetable absolute
memory reference" needs for inline asm, as GS/FS-prefixed addresses
would be just fine.

> Of course, because I didn't read your entire mail, converting only regs=
 to be
> per-CPU didn't help.  It actually made things worse (TIL the INIT test =
shares
> a VMCS between CPUs... WTF).

Hah! This rabbit hole has way to many branches!

>=20
> After making launch and in_guest per-CPU, and using RAX to communicate =
hypercalls,

Nice! The use of a global 'hypercall_field' for communicating the
intended hypercall was just puzzling to me. Using registers is such a
more natural way of doing it.

> I've got everything passing (module one unsolvable SIPI wart; see below=
).  I need
> to write changelogs and squash a few fixups, but overall it ended up be=
ing a nice
> cleanuped (de-duplicating the VMX vs. SVM GPR handling drops a lot of c=
ode).  I'm
> tempted to delete a blank lines just to get to net negative LoC :-D
>=20
>  lib/x86/smp.h       |  32 ++++++++++++++++++++++++++++++++
>  lib/x86/virt.h      |  61 ++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++
>  x86/Makefile.common |  14 ++++++++++++++
>  x86/realmode.c      |   3 +++
>  x86/svm.c           |  19 ++++++++-----------
>  x86/svm.h           |  61 +++++++++-----------------------------------=
-----------------
>  x86/svm_tests.c     |   5 +++--
>  x86/vmx.c           | 122 ++++++++++++++++++++++++++++++++++++++++++++=
++++++++++++++-----------------------------------------------------------=
-----
>  x86/vmx.h           |  72 +++-----------------------------------------=
----------------------------
>  x86/vmx_tests.c     | 104 ++++++++++++++++++++++++++++++++++++++++++++=
++++++++++++------------------------------------------------
>  10 files changed, 247 insertions(+), 246 deletions(-)

Not too bad!

>=20
>> To see the register corruption, one could start the vmx_sipi_signal_te=
st
>> test with -s -S, attach gdb to it and add a watch for regs.rax. Steppi=
ng
>> through the test will clearly show how 'regs' get overwritten wrongly.=

>=20
> The test itself is also flawed.  On top of this race that you spotted:
>=20
>  @@ -9985,11 +9985,11 @@ static void vmx_sipi_signal_test(void)        =
       =20
>        /* update CR3 on AP */                                          =
       =20
>        on_cpu(1, update_cr3, (void *)read_cr3());                      =
       =20
>                                                                        =
       =20
>  +     vmx_set_test_stage(0);                                          =
       =20
>  +                                                                     =
       =20
>        /* start AP */                                                  =
       =20
>        on_cpu_async(1, sipi_test_ap_thread, NULL);                     =
       =20
>                                                                        =
       =20
>  -     vmx_set_test_stage(0);                                          =
       =20
>  -                                                                     =
       =20
>        /* BSP enter guest */                                           =
       =20
>        enter_guest();                                                  =
       =20
>   }                               =20
>=20
> This snippet is also broken:
>=20
> 	vmx_set_test_stage(1);
>=20
> 	/* AP enter guest */
> 	enter_guest();
>=20
> because the BSP can think the AP has entered WFS before it has even att=
empted
> VMLAUNCH.  It's "fine" so long as there are host CPUs available, but th=
e test
> fails 100% for me if I run KUT in a VM with e.g. j<number of CPUs>, and=
 on an
> Ivybridge server CPU, it fails pretty consistently.  No idea why, maybe=
 a slower
> nested VM-Enter path?  E.g. the test passes on EMR even if I run with j=
<2x CPUs>.

Yeah, I noticed the failing synchronization between the vCPUs too. I
even tried to fix them by introducing a few more states (simply more
steps). However, then I ended up in deadlocks, as the AP re-enters
vmx_sipi_test_guest() multiple times (well, twice). It was likely
related to the register corruption, I only noticed later. So I believed
those magic sleeps (delay(SIPI_SIGNAL_TEST_DELAY)) are for the lack of
synchronization and should account for the time span of the AP setting a
new step value but not yet having switched to the guest.
It might be worth revisiting my attempts of explicitly adding new step
states, now with the register corrupting being handled...

>=20
> Unfortunately, I can't think of any way to fix that problem.  To recogn=
ize the
> SIPI, the AP needs to do VM-Enter with a WFS activity state, and I'm st=
ruggling
> to think of a way to atomically write software-visible state at the tim=
e of VM-Enter.
> E.g. in theory, the test could peek at the LAUNCHED field in the VMCS, =
but that
> would require reverse engineering the VMCS layout for every CPU.  If KV=
M emulated
> any VM-wide MSRs, maybe we could throw one in the MSR load list?  But a=
ll the ones
> I can think of, e.g. Hyper-V's partition-wide MSRs, aren't guaranteed t=
o be available.

Ahh, that explains the deadlock I observed. So adding more states won't
help. Yeah, it needs some trickery... or those magic sleeps :D

>=20
> Anywho, now that I know what to look for, I can ignore false failures e=
asily enough.
> If someone cares enough to come up with a clever fix, then yay.  Otherw=
ise, I'll
> just deal with the intermittent failures (or maybe nuke and pave).

>=20
> As for this patch, I'll write changelogs and get a series posted with t=
he backtrace
> and realmode patch at the end.

Thanks a lot for picking up the work! For me, KUT is far from my daily
work, so spending time on it cuts on the time budget what I'm actually
supposed to do. After having spent nearly a week in chasing that bug
made me realize, the work to fix it properly would be, at least for me,
yet another week and I didn't had the time for it back then.

Of course, if changes of mine cause regressions, I feel strongly
obligated to fix these -- even if it isn't my code's fault after all.
However, in this case, I just didn't found the time to do so yet. So
thanks again for working on this!

I'll be off for the season from tomorrow on, so may not provide instant
feedback for the series, in case you post it in the next couple of days.
But I'm looking forward reviewing it! :)

One more thing. I was able to land the gcc bug fix[1], so the realmode
patch could be reworded to mention that only "pre gcc-16" is broken but
the patch is still needed as gcc 16 isn't even released yet and far from
being the minimal supported version for KUT.

Thanks,
Mathias

[1] https://gcc.gnu.org/git/?p=3Dgcc.git;a=3Dcommitdiff;h=3D114a19fae9bd

--------------xVM07hl82XkYJQAQxvVwBdAq--

--------------u0IehbX85HN0timF1oZrFJU4
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsD5BAABCAAjFiEEd7J359B9wKgGsB94J4hPxYYBGYYFAmlD0lMFAwAAAAAACgkQJ4hPxYYBGYYP
FgwAn8BB2vS3VNxqG7q2yVG20BQmKHXDNwHp+Ghs5nLOQSrOY5rAlGpahWzga9xdkX8n8YdTCYvz
iXzwCtX5Ct8GJmspuZGIJsH5ZUsO3HiuN8xUs8KGkSLOFNbC1T7dmrTns8VKbmBJkZR55nWb6b2R
CSAvq8dsPHd3bd8HXUd32MDZ5HDOXB+LVP28jTLbs/6MJ8QQOoskxW8ZocmlSPiM4LTSmNIKUV6s
nOHAWLBlIrgO6NStJaD+P6Jm5z5bCdfJa64dq5mVHqt06qhTaU+P+/5GHmNWDNAEyfGkqD1mES5M
68qK7dHo0XE6ELWKtHUJ0gU9FfY3sL1OSbcZSBRHm+6tLzEmNaZiDokz40Raan1Lmj5LjxZBEf0E
quxhpZdi8pm9ZJDSuIJKMKKGAzwjXt9SUVLAPw77fnilHISGx9d1xhIHN0AOucwtz2YYG/CDDK5Y
WjzYZQIpI1Z2HHXU7O4MW6E3uk5C5wimcHEndYMM2xoQU6oYtIhkBJ//9PNW
=gIea
-----END PGP SIGNATURE-----

--------------u0IehbX85HN0timF1oZrFJU4--
