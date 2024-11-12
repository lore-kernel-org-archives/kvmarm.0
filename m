Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85251205E12
	for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 16:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731429052; cv=none; b=KOv8jU2URbTyyCFSGhU58j66sQij6xQZfyOg7+VYREeRBVtQ5yi1Jnx7O3D78Eh4oVFCudyYkubo1UwCAjkFFjoVkZbUoT8FF4crJkjNTbGySK/jNNvdStKu8RNPBe7kXgUrRH7uE0e6Hi74sN8SC2eTHa2ArbgRtzz7EtpRarg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731429052; c=relaxed/simple;
	bh=9efVBDaOj+NotMkSdM+uuNcfbkXRmF5g6Bq4LECl9mw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Zd782NIESAGahhSyLJ3lpLRFE1vTjVPgBDAXA9CKqU1IvJyfc3zwQomyokBjqVLDA7Vk1IOO0FP6BDSS7fiPT0v8FdylGeujbpZZJ81dLkS3zlL5CpXfeU+TK28yzSLCpwUgR3HvjvtyQEIiXtIDM31M7fo7ZCQzikiPpuX99gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JtlYXdjJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JtlYXdjJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731429049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LYLr+rh5hOZBfdtfKnkZ93awofZ11kfZdonr2arSeaw=;
	b=JtlYXdjJl1tr6ZuPw+sCxSRBFzxsPQwRqx2etLpJO2eocnv0AzbdTXz62rkO5GA1ovMm7t
	dUJrjPUas2pR5NDMgALkZgOPUiQERUrMjAQQwvtn/PIebpcsURJpxcqAH62YgZOmV60oDG
	wVYfdmP/+aW0aB55pDk70qgb/Lb93GU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-332-qD_3M_D0MZ-H7d9sdBjsew-1; Tue,
 12 Nov 2024 11:30:45 -0500
X-MC-Unique: qD_3M_D0MZ-H7d9sdBjsew-1
X-Mimecast-MFC-AGG-ID: qD_3M_D0MZ-H7d9sdBjsew
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5DB4A1956095;
	Tue, 12 Nov 2024 16:30:37 +0000 (UTC)
Received: from localhost (unknown [10.39.194.144])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E75C31956089;
	Tue, 12 Nov 2024 16:30:34 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger@redhat.com, =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Peter
 Maydell <peter.maydell@linaro.org>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
In-Reply-To: <87ikstn8sc.fsf@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-19-eric.auger@redhat.com>
 <ZxuX4i9NjVRizB72@redhat.com>
 <cb6c8f62-c5dc-416d-865f-fbdf96164dac@redhat.com>
 <Zxub7ol4p8P_sWF8@redhat.com>
 <CAFEAcA_wQu17y0PyQwxw0wuf2H5y2VE5aX16nLP2-u7QUP2ggA@mail.gmail.com>
 <Zx-9WxXkmkMuGIlQ@redhat.com>
 <CAFEAcA9w0mb5bcU8p+fScQony-=oqLmNurGWpnL_sBneQCzxUg@mail.gmail.com>
 <Zx_EGxj2aqc_2-kY@redhat.com>
 <63c232c2-a325-48d6-8ed4-753a7c6e3b4e@redhat.com>
 <87ikstn8sc.fsf@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 12 Nov 2024 17:30:32 +0100
Message-ID: <87frnwmn2v.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Nov 11 2024, Cornelia Huck <cohuck@redhat.com> wrote:

> On Mon, Nov 04 2024, Eric Auger <eric.auger@redhat.com> wrote:
>
>> Hi Daniel,
>>
>> On 10/28/24 18:04, Daniel P. Berrang=C3=A9 wrote:
>>> On Mon, Oct 28, 2024 at 04:48:18PM +0000, Peter Maydell wrote:
>>>> On Mon, 28 Oct 2024 at 16:35, Daniel P. Berrang=C3=A9 <berrange@redhat=
.com> wrote:
>>>>> On Mon, Oct 28, 2024 at 04:16:31PM +0000, Peter Maydell wrote:
>>>>>> On Fri, 25 Oct 2024 at 14:24, Daniel P. Berrang=C3=A9 <berrange@redh=
at.com> wrote:
>>>>>>> On Fri, Oct 25, 2024 at 03:18:25PM +0200, Eric Auger wrote:
>>>>>>>> On 10/25/24 15:06, Daniel P. Berrang=C3=A9 wrote:
>>>>>>>>> Also, is this naming convention really the same one that users
>>>>>>>>> will see when they look at /proc/cpuinfo to view features ? It
>>>>>>>> No it is not. I do agree that the custom cpu model is very low lev=
el. It
>>>>>>>> is very well suited to test all series turning ID regs as writable=
 but
>>>>>>>> this would require an extra layer that adapts /proc/cpuinfo feature
>>>>>>>> level to this regid/field abstraction.
>>>>>>>>
>>>>>>>> In /cpu/proc you will see somethink like:
>>>>>>>>  Features    : fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics =
fphp
>>>>>>>> asimdhp cpuid asimdrdm lrcpc dcpop asimddp
>>>>>>> Right, IMHO, this is the terminology that QEMU must use in user
>>>>>>> facing APIs.
>>>>>> /proc/cpuinfo's naming is rather weird for historical
>>>>>> reasons (for instance there is only one FEAT_FP16 feature
>>>>>> but cpuinfo lists "fphp" and "asimdhp" separately).
>>>>> There's plenty of wierd history in x86 too. In this
>>>>> case I might suggest just picking one of the two
>>>>> common names, and ignoring the other.
>>>>>
>>>>> If we really wanted to, we could alias the 2nd name
>>>>> to the first, but its likely not worth the bother.
>>>> Or we could use the standard set of architectural
>>>> feature names, and not have the problem at all, and not
>>>> have to document what we mean by our nonstandard names.
>>>> (cpuinfo names do actually mostly line up with the
>>>> standard names, just not 100%. Similarly gcc/clang command
>>>> line options are mostly the architectural feature name.)
>>> Ah, right, yes. Sorry I mis-understood you originally to be suggesting
>>> the same low level names as this patch.
>> If my understanding is correct, Peter suggested to rely on the
>> terminology used in
>>
>> https://developer.arm.com/documentation/109697/2024_09
>>
>> the doc pointed to by Oliver.
>>
>> So I think the next step is to understand how those "high level" feature=
s do map onto low level ID register field values. I think a high level feat=
ure can map onto separate fields in separate ID regs. This may not be the m=
ost common case though.=20
>
> I went through all the FEAT_xxx features defined so far and tried to
> categorize them (probably with some errors here and there, but the
> general trend should be correct.)
>
> There's 335 features defined at the moment.
>
> Of these, the majority (295 by my count) map to one or more values in
> one or more id registers. These are what I'd consider the "easy" ones
> (added complexity if we deal with serveral values, but in general, it is
> clear how to handle them, and most of them actually map to a single
> value.) Of course, dependencies may be on top of that.
>
> Then, we have some features (~25 or so) that are actually defined by
> dependencies (i.e. FEAT_FOO and FEAT_BAR mean that we have FEAT_BAZ,
> sometimes with an architecture extension dependency thrown in as well.)
> These features are not really relevant when we compare two cpus since
> they do not map to registers directly, but they are relevant if we allow
> them to be specified (and use them as a kind of shorthand.) IOW, we'd
> need to think about how we'd handle them for comparisons and baselining.
>
> Next, let's talk about architecture extensions. All features have a
> level where they have been introduced as optional, some have an upper
> limit (e.g. FEAT_AA32EL1 is not allowed from v9.0 onwards), and quite a
> number of them (~65 or so) become mandatory with a certain architecture
> extension. Sometimes, FEAT_FOO + arch ext also implies FEAT_BAR. If we
> introduce Armvx.y named models, we'd need to enforce that some features
> are (not) set for a certain model. Complex, but not a showstopper. (We'd
> also need to deal with that if we worked on the register level.)
>
> We also have some registers like MIDR/REVIDR that do not correlate with
> any FEAT_xxx, but that we still need to handle; I would suggest to deal
> with them via separate cpu properties (e.g. specify a list of possible
> MIDR/REVIDR pairs.) I hope that there are not too many of them, although
> we do have some impdef registers.
>
> That leaves some headscratchers (at least for me.) E.g. FEAT_UINJ, which
> is optional from v9.5, and mandatory from v9.6, but where I'm unsure how
> we'd discover it, especially as we do not have a way to discover the
> architecture extensions. Maybe this will work for named actual cpus
> only? I'm also not sure if I understand FEAT_CHK, which is listed as
> optional from v8.0 and mandatory from v9.4, but every aarch64 cpu is
> supposed to be compliant, because CHKFEAT might be a NOP (and this is
> only supposed to check for FEAT_GCS? Yes, I'm confused.)
>
> So tl;dr, we cover a lot of the ID register space via FEAT_xxx (with
> varying complexity), but we already know about some exceptions. For some
> FEAT_xxx, I'm not sure if we want to handle them at all.
>
> (I also seem to remember that there some things like perf counters that
> don't map to any on/off features, but no idea about the details here.)

Following up on this, some ideas/questions on how a command line could
look like and behave.

Let's say we introduce Armv80, Armv81, ... models for the architecture
extensions and optionally named models for individual cpus we care about
(e.g. My85BasedCpu which would be Armv85 + some stuff on top). The
Armv<xy> models would come with all mandatory features turned on and
would allow all optional features to be set or unset, with
(accelerator-specific) verification on top.

Let's assume that we have

-cpu Armv80,FEAT_AdvSIMD=3Don,FEAT_FP=3Don

Since the two features provide each other, I'd assume

-cpu Armv80,FEAT_AdvSIMD=3Don

or

-cpu Armv80,FEAT_FP=3Don

to be equivalent, and

-cpu Armv80,FEAT_AdvSIMD=3Don,FEAT_FP=3Doff

to generate an error. Question: at which level? s390x does dependency
validation in QEMU, we could do it as well, but I think we have way more
dependencies on Arm.

Also, let's take FEAT_BTI, which is optional for 8.4 and mandatory from
8.5 onwards. I'd expect

-cpu Armv84,FEAT_BTI=3Don   <-- ok
-cpu Armv84  same as -cpu Armv84,FEAT_BTI=3Doff
-cpu Armv85 same as -cpu Arm84,FEAT_BTI=3Don
-cpu Armv85,FEAT_BTI=3Doff  <-- Error!

When doing baselining while looking at id registers, we'd get

ID_AA64PFR1_EL1.BT =3D=3D 1 -> must use Armv84 or later
ID_AA64PFR1_EL1.BT =3D=3D 0 -> must use Armv84 or earlier

(unfortunately, some other features are more complex...)

Would

-cpu Armv84,<all 8.5 mandatory bits>

generate the same cpu as

-cpu Armv85

(and therefore, the two be migratable between each other?)

If we create named cpu models for individual cpus, e.g.

-cpu My85BasedCpu

as equivalent to

-cpu Armv85,FEAT_FOO=3Don,FEAT_BAR=3Don

Should we allow

-cpu My85BasedCpu,FEAT_BAR=3Doff

or would the command line need to be

-cpu Armv85,FEAT_FOO=3Don

(e.g. to deal with not all id regs being writable?)

Regardless of what we end up doing for features and cpu models, we'll
need to be able to specify registers that do not correlate to any
features; especially for things like MIDR/REVIDR, where we'll want to
provide a list of possible target values as pairs;

-cpu Armv85,midr_revidr=3D(<value>,<value>)

is ugly, and figuring the actual values is not user friendly at all, I
fear :(

And now, at the end of this long email, the most important questions:
What colour should the features have?

Matching the architecture: FEAT_AdvSIMD, FEAT_FP, FEAT_BTI

Dropping "FEAT_": AdvSIMD, FP, BTI

Less shouty: feat_advsimd, feat_fp, feat_bti

Less shouty and shorter: advsimd, fp, bti  -- in this case we'd need to
be careful because we already have sve/sme props, and I'm not sure if we
could do some sugaring without conflicts.

Thoughts?

