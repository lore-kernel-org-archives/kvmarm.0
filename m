Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C1418893C
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 16:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730132964; cv=none; b=d1DLzdaThkenpKRSlNQ9OZXLke1cz7vpsM/ZQarSRr5o9Fwt1MWc5CYLJPdNOXGMap7qpFRRDPGCYbO23LYodRQJLVdCbD/Pcmj2GmnCRSB8eMndk1n954TXVFt940UjjDfUfTZzcjIGfpYgyO/Kn/sk8AhOaIWAh6qJCRF1tB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730132964; c=relaxed/simple;
	bh=mWMB9u+W2V6dTh3jud0NeAKsAEjUv+CqtCPFeltEcUI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fyYEGQR/ljX9uDI4IJFzycI1BqclGKPUHQSHHePn4e2je3kHGWpPt2xhIxIUD3zEqSsPcpZ7zEJCjALAykZ+b2iJBEXkImQ6ck5oWbtjIVzjdZyHlcGhv2f4XqjyIRhrJU4UD3mIdwLNdXc5uZ6EezrdvBVfRvxRAKx/9Z6F+Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UxnT4oD7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UxnT4oD7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730132961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mkkVElKn3Spk/fVm1hzjR0gsXNh0JNd5hSe/vYQwfCU=;
	b=UxnT4oD7C2X4Cn7SPrQSEaFpst1tk3nHFqcVG9bg2tv/NVdUmImAb9w1fxIoqUXI4SjMzY
	xDxcHSbnXwqtELJ2Rh9CMJ+Ulz01cRmS/5xezUotvHfPOsE9+IF4qZ42O0TxMP4ew6+6Ok
	4s80602c0Fi82TU7kvxllaT7lwo53GA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-26-LhHf3dMWMJeGWk7sEJHcIQ-1; Mon,
 28 Oct 2024 12:29:18 -0400
X-MC-Unique: LhHf3dMWMJeGWk7sEJHcIQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1572F1955D4A;
	Mon, 28 Oct 2024 16:29:16 +0000 (UTC)
Received: from localhost (unknown [10.22.88.106])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 52E9919560AA;
	Mon, 28 Oct 2024 16:29:14 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [RFC 21/21] arm/cpu-features: Document custom vcpu model
In-Reply-To: <Zx-3OUioG1l47hW3@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-22-eric.auger@redhat.com>
 <ZxuZkUFz_bwAA1pf@redhat.com>
 <0700af51-a1a6-4b11-a4bf-0eaf6e279c6d@redhat.com>
 <Zxudl5-fZV1vIaEL@redhat.com> <87y128nrfr.fsf@redhat.com>
 <Zx-3OUioG1l47hW3@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 28 Oct 2024 17:29:11 +0100
Message-ID: <87plnknqco.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, Oct 28 2024, Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:

> On Mon, Oct 28, 2024 at 05:05:44PM +0100, Cornelia Huck wrote:
>> On Fri, Oct 25 2024, Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:
>>=20
>> > On Fri, Oct 25, 2024 at 03:28:35PM +0200, Eric Auger wrote:
>> >> Hi Daniel,
>> >>=20
>> >> On 10/25/24 15:13, Daniel P. Berrang=C3=A9 wrote:
>> >> > On Fri, Oct 25, 2024 at 12:17:40PM +0200, Eric Auger wrote:
>> >> >> From: Cornelia Huck <cohuck@redhat.com>
>> >> >>
>> >> >> Add some documentation for the custom model.
>> >> >>
>> >> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> >> >> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> >> >> ---
>> >> >>  docs/system/arm/cpu-features.rst | 55 +++++++++++++++++++++++++++=
-----
>> >> >>  1 file changed, 47 insertions(+), 8 deletions(-)
>> >> >
>> >> >> @@ -167,6 +196,16 @@ disabling many SVE vector lengths would be qu=
ite verbose, the ``sve<N>`` CPU
>> >> >>  properties have special semantics (see "SVE CPU Property Parsing
>> >> >>  Semantics").
>> >> >>=20=20
>> >> >> +The ``custom`` CPU model needs to be configured via individual ID=
 register
>> >> >> +field properties, for example::
>> >> >> +
>> >> >> +  $ qemu-system-aarch64 -M virt -cpu custom,SYSREG_ID_AA64ISAR0_E=
L1_DP=3D0x0
>> >> >> +
>> >> >> +This forces ID_AA64ISAR0_EL1 DP field to 0.
>> >> > What is the "baseline" featureset implied by 'custom' ?
>> >> there is no baseline at the moment. By default this is a host
>> >> passthrough model.
>> >
>> > Why do we need to create "custom" at all, as opposed to just letting
>> > users toggle features on "-cpu host" ?=20
>>=20
>> We could consolidate that to the current "host" model, once we figure
>> out how to handle the currently already existing properties. Models
>> based on the different architecture extensions would probably be more
>> useable in the long run; maybe "custom" has a place for testing.
>
> If you can set the features against "host", then any testing could
> be done with "host" surely, making 'custom' pointless ?

We might differentiate between "do some consistency checks" and "allow
a completely weird wolpertinger"; if we agree that we don't need it,
then we surely could drop it again.

