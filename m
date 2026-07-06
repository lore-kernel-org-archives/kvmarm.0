Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7E82D77E6
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 12:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783340904; cv=none; b=neeYspL25t7jtPisEszikJDpejeDcZvGWoczT0TLkbMHbvwBHAHz+KS7IX6uvecJaNiQ+grqLwayPAixAla90NpZwCmMzWoy88ItusD9gYyhFwp0/keyU0+aVKDbHMcndLYQNc7X955VT4qij45Uz7w02mUIQ9YVY4o9t7Y1SlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783340904; c=relaxed/simple;
	bh=/b4yVFtykcJoZcuJeAlKuc9DiPvEfwYPqmfc9bpC8F8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mSFgxCyvI0SA5VdHzIZ2DPotUE0pl+zgRoQE7mC+MxMUrZMM8SEtZ0BZ3zZaUrnLJYzq4Eb5cv1tmoeXp20u34tvgxziSgMQ7q9Y0ocAXoEbLOj6kUgrqcK3ukRDMhe9/Mb0AcbIS0Qlv8A3JjpolOLH8dqBSgE8MMCgTydoA08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cy/51REM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cy/51REM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783340901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FZzSbm7Ez8GEPaBEfn/F46GcrexUMxp3tIXA7R9WRP4=;
	b=cy/51REMNg383M6Y8VoWvc191e8VC364JoTcq8mngZqNRAs1dBHNXtdSPt6yTT7XLqJXKT
	LSF0uX5a9CNAJl7fmaXXfBD3cQBd3G4FFUj5Yt89aYQMr811D45JV2oJtngS0f471DyJ9F
	8EqTKj7KxPTLBjTQqS1oz57XHPylMWc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-491-_YMTVc6jMCKsXf5Oy3TLOg-1; Mon,
 06 Jul 2026 08:28:18 -0400
X-MC-Unique: _YMTVc6jMCKsXf5Oy3TLOg-1
X-Mimecast-MFC-AGG-ID: _YMTVc6jMCKsXf5Oy3TLOg_1783340896
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 45FA41955F11;
	Mon,  6 Jul 2026 12:28:15 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.4])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4EA961956087;
	Mon,  6 Jul 2026 12:28:14 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id C90E421E6920; Mon, 06 Jul 2026 14:28:11 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,  "qemu-arm@nongnu.org"
 <qemu-arm@nongnu.org>,  "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
  Eric Auger <eric.auger@redhat.com>,  Cornelia Huck <cohuck@redhat.com>,
  Peter Maydell <peter.maydell@linaro.org>,  Richard Henderson
 <richard.henderson@linaro.org>,  Marc Zyngier <maz@kernel.org>,  Oliver
 Upton <oliver.upton@linux.dev>,  Daniel P . =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Andrea Bolognani <abologna@redhat.com>,  Jiri
 Denemark <jdenemar@redhat.com>,  Gavin Shan <gshan@redhat.com>,  Shameer
 Kolothum <skolothumtho@nvidia.com>,  Sebastian Ott <sebott@redhat.com>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Jinqian Yang
 <yangjinqian1@huawei.com>,  Shaju Abraham <shaju.abraham@nutanix.com>,
  Mark Cave-Ayland <mark.caveayland@nutanix.com>,  Sandesh Patel
 <sandesh.patel@nutanix.com>
Subject: Re: [RFC PATCH v2 23/29] target/arm/qmp: add query-arm-cpu-props-info
In-Reply-To: <17B524D0-6D08-4ECF-93FC-E38EB0F8F6D7@nutanix.com> (Khushit
	Shah's message of "Fri, 19 Jun 2026 11:54:19 +0000")
References: <20260605083358.1320563-1-khushit.shah@nutanix.com>
	<20260605083358.1320563-24-khushit.shah@nutanix.com>
	<87o6h6hofm.fsf@pond.sub.org>
	<17B524D0-6D08-4ECF-93FC-E38EB0F8F6D7@nutanix.com>
Date: Mon, 06 Jul 2026 14:28:11 +0200
Message-ID: <87bjcknvz8.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: Q4aUbLFnavZeHPrzmGFiOSn-xjRu-GuusHMV-ZT90ls_1783340896
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I apologize for taking so long to reply.

Khushit Shah <khushit.shah@nutanix.com> writes:

>> On 19 Jun 2026, at 2:55=E2=80=AFPM, Markus Armbruster <armbru@redhat.com=
> wrote:
>>=20
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>=20
>> |-------------------------------------------------------------------!
>>=20
>> Khushit Shah <khushit.shah@nutanix.com> writes:
>>=20
>>> Introduce 'query-arm-cpu-props-info' QMP command. This command returns
>>> information about ARM CPU model properties, including their name, type,
>>> supported values on the given host, and composite parent if any.
>>>=20
>>> This provides management layer necessary information to determine
>>> migration compatibility off a VM on different host.
>
> Note: s/off/of.
>
>>>=20
>>> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
>>> ---
>>> qapi/misc-arm.json              | 41 ++++++++++++++++
>>> stubs/qmp-arm-gic.c             |  6 +++
>>> target/arm/arm-cpu-props-stub.c | 13 +++++
>>> target/arm/arm-cpu-props.c      | 85 +++++++++++++++++++++++++++++++++
>>> target/arm/arm-cpu-props.h      |  5 ++
>>> target/arm/arm-qmp-cmds.c       | 44 +++++++++++++++++
>>> target/arm/cpu-idregs.c         | 71 +++++++++++++++++++++++++++
>>> target/arm/cpu-idregs.h         |  8 ++++
>>> 8 files changed, 273 insertions(+)
>>>=20
>>> diff --git a/qapi/misc-arm.json b/qapi/misc-arm.json
>>> index 4dc66d00e5..1a3fb140c4 100644
>>> --- a/qapi/misc-arm.json
>>> +++ b/qapi/misc-arm.json
>>> @@ -46,6 +46,47 @@
>>> ##
>>> { 'command': 'query-gic-capabilities', 'returns': ['GICCapability'] }
>>>=20
>>> +##
>>> +# @CpuPropInfo:
>>=20
>> CpuPropertyInfo for consistency with type names such as ObjectPropertyIn=
fo.
>
> Acked.=20
>
>>> +#
>>> +# Information about a specific ARM CPU model property.
>>> +#
>>> +# @name: the name of the property
>>> +#
>>> +# @type: the type of the property, any of ('string', 'boolean',
>>> +#     'number').
>>> +#
>>> +# @supported-values: the set of values the host hardware supports
>>> +#     for the property, a list of strings.
>>=20
>> I figure the set of values depends on the host, i.e. it isn't known at
>> compile time.  Correct?
>>=20
>
> Yes, correct.
>
>> Are the possible property names known at compile time?
>
> Yes, property names are known at compile time.

Why can't we use a struct then?

    { 'struct': ...
      'data': {
          'PROP1': 'TYPE1',
          'PROP2': 'TYPE2',
          ... } }

>> List of strings is fine when the values are strings.  When they're not,
>> the interface requires its users to parse strings, which is something we
>> try hard to avoid in QAPI/QMP.
>
> Okay, then I think we can do this with flat union discriminated with=20
> =E2=80=9Ctype=E2=80=9D (changing it to enum) :
>    boolean: [=E2=80=98bool=E2=80=99]
>    string: [=E2=80=99str=E2=80=99]
>    number: ['NumRange=E2=80=99] where NumRange: {=E2=80=98min=E2=80=99: u=
int64, =E2=80=98max=E2=80=99: uint64}
>
> Range form to handle numeric properties with no restrictions.
>
> Does this look reasonable to you?

Yes, this is a reasonable way to do dynamic typing in QAPI.

I still need to understand why you you dynamic types here.

[...]

