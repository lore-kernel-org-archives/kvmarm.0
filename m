Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C248289A
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 16:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734368345; cv=none; b=bJ3j6/0x1EnPgr49O6Tlt7/jwtSxPph6E0L59995ggR/VG5EV7prNcsRD0byw5OfAil8rQsHPCW92GiVhHxhTtv+mkupxVQf4+ecikxe+ssHRllSNOHq0sKzuNKlX5K3ZcnNZHfXRpjvieZMllR80HAwiBEnhgsJ1VuaneedXKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734368345; c=relaxed/simple;
	bh=q1Ov2XF8Bfd0lpNvypBIiw/JaUwz0bdBJBIkRN/Bo30=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cqHWRLyTi4DPRAzdfDruxf6b/HAjbI22CxgWfdtVXUBcSBm669zrb8ijkpobo3KoGUns5cHuSxaG7u3MNvNaxZab6THg1OAi0+iUbbFLi2uk4h9rOTwK/hEpEzGigPuvYIeI6ATbOC7gdoLayswaotg5sGDU60gyc7CnmBkGP/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cJEZX+Ck; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cJEZX+Ck"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734368342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q1Ov2XF8Bfd0lpNvypBIiw/JaUwz0bdBJBIkRN/Bo30=;
	b=cJEZX+Ckd0eUcIV0y4oU/7ODYRS5VHzH4uvXiSp3ejwZLmP12+nJF7/X3LzZD9Cgb9IwQx
	BOPYIP97d0NqHDU9sor40axuGK+KUl2M7jbrUHVCtECB24zjVME8iNfPUeFEVmgSOZby2s
	Zd2ahjNQr4cN8tNnjHjzW1rLjEOit8A=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-aL26ZOMIOXKwalJGZKkHpA-1; Mon,
 16 Dec 2024 11:58:53 -0500
X-MC-Unique: aL26ZOMIOXKwalJGZKkHpA-1
X-Mimecast-MFC-AGG-ID: aL26ZOMIOXKwalJGZKkHpA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A53311955EC7;
	Mon, 16 Dec 2024 16:58:45 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C6ADA1956056;
	Mon, 16 Dec 2024 16:58:43 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [PATCH RFCv2 00/20] kvm/arm: Introduce a customizable aarch64
 KVM host model
In-Reply-To: <87wmfzbmut.fsf@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241206112213.88394-1-cohuck@redhat.com>
 <edc12140-6345-4868-938d-c80c4d2c2004@redhat.com>
 <87wmfzbmut.fsf@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 16 Dec 2024 17:58:40 +0100
Message-ID: <87ttb3bm4f.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Dec 16 2024, Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu, Dec 12 2024, Eric Auger <eric.auger@redhat.com> wrote:
>
>> Connie,
>>
>> On 12/6/24 12:21, Cornelia Huck wrote:
>>> Whether it make sense to continue with the approach of tweaking values =
in
>>> the ID registers in general. If we want to be able to migrate between c=
pus
>>> that do not differ wildly, we'll encounter differences that cannot be
>>> expressed via FEAT_xxx -- e.g. when comparing various AmpereAltra Max s=
ystems,
>>> they only differ in parts of CTR_EL0 -- which is not a feature register=
, but
>>> a writable register.
>> In v1 most of the commenters said they would prefer to see FEAT props
>> instead of IDREG field props. I think we shall try to go in this
>> direction anyway. As you pointed out there will be some cases where FEAT
>> won't be enough (CTR_EL0 is a good example). So I tend to think the end
>> solution will be a mix of FEAT and ID reg field props.
>
> Some analysis of FEAT_xxx mappings:
> https://lore.kernel.org/qemu-devel/87ikstn8sc.fsf@redhat.com/
>
> (actually, ~190 of FEAT_xxx map to a single value in a single register,
> so mappings are easy other than the sheer amount of them)
>
> We probably should simply not support FEAT_xxx that are solely defined
> via dependencies.
>
> Some more real-world examples from some cpu pairings I had looked at:
> https://lore.kernel.org/qemu-devel/87ldx2krdp.fsf@redhat.com/
> (but also see Peter's follow-up, the endianness field is actually
> covered by a feature)
>
> The values-in-registers-not-covered-by-features we are currently aware
> of are:
> - number of breakpoints
> - PARange values
> - GIC
> - some fields in CTR_EL0
> (see also
> https://lore.kernel.org/qemu-devel/4fb49b5b02bb417399ee871b2c85bb35@huawe=
i.com/
> for the latter two)

And the differences in GIC might be actually due to a GICv3 not being
configured, together with running a recent kernel, which will zero the
field. So we might actually already be able to handle it for most cases.

>
> Also, MIDR/REVIDR handling.
>
> Given that we'll need a mix if we support FEAT_xxx, should we mandate
> the FEAT_xxx syntax if there is a mapping and allow direct specification
> of register fields only if there is none, or allow them as alternatives
> (with proper priority handling, or alias handling?)
>
>>
>> Personally I would smoothly migrate what we can from ID reg field props
>> to FEAT props (maybe using prop aliases?), starting from the easiest 1-1
>> mappings and then adressing the FEAT that are more complex but are
>> explictly needed to enable the use cases we are interested in, at RedHat:
>> migration within Ampere AltraMax family, migration within NVidia Grace
>> family, migration within AmpereOne family and migration between Graviton=
3/4.
>
> For these, we'll already need the mix (my examples above all came from
> these use cases.)
>
> (Of course, the existing legacy props need to be expressed as well. I
> guess they should map to registers directly.)
>
>>
>> We have no info about other's use cases. If some of you want to see some
>> other live migration combinations addressed, please raise your voice.
>> Some CSPs may have their own LM solution/requirements but they don't use
>> qemu. So I think we shall concentrate on those use cases.
>>
>> You did the exercise to identify most prevalent patterns for FEAT to
>> IDREG fields mappings. I think we should now encode this conversion
>> table for those which are needed in above use cases.
>
> I'd focus on the actually needed features first, as otherwise it's
> really overwhelming.
>
>>
>> From a named model point of view, since I do not see much traction
>> upstream besides Red Hat use cases, targetting ARM spec revision
>> baselines may be overkill. Personally I would try to focus on above
>> models: AltraMax, AmpereOne, Grace, ... Or maybe the ARM cores they may
>> be derived from. According to the discussion we had with Marc in [1] it
>> seems it does not make sense to target migration between very
>> heterogeneous machines and Dan said we would prefer to avoid adding
>> plenty of feat add-ons to a named models. So I would rather be as close
>> as possible to a specific family definition.=C2=A0 =C2=A0
>
> Using e.g. Neoverse-V2 as a base currently looks most attractive to
> me -- going with Armv<x>.<y> would probably give a larger diff (although
> the diff for Graviton3/4 is pretty large anyway.)
>
>>
>> Thanks
>>
>> Eric
>>
>> [1]
>> https://lore.kernel.org/all/c879fda9-db5a-4743-805d-03c0acba8060@redhat.=
com/#r

