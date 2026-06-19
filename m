Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D07351C3B
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 09:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781861145; cv=none; b=GjCo6WfFx7z12l1YYx+RPQXVcbTLf51sMwmKOT62EK5shlJ9ZQC8Bxt4nE7ZWA3tqmGLHw/dyxBecUMAa1tSh2+PL2BppqBWyOjbvflkJGtQ32pFpeue78CF4FQSRurLrNVPM9VxykFxTQguoa1ZpEgu5nY1NYxlPT95ZfhlXNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781861145; c=relaxed/simple;
	bh=BN4fmTWE6ML+qnpFbSTS8jw12sbBrjuV7Vz/EPPbqcY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rz7RhXUxP120zUxn774Yn9RZbBzJKkV6/x2C8ApW8Yr30HY47EOFXaygqcvkHbDwk48SFinlaKnXIsNw6TZ6bqxMmhZtv3MGkfJxSeN/DLbetXMVspT0ZMlfBeLH5yYubtdXrk1yulh4D3xzpBN9iCKnq/vYiHJSgF7cVrGgwZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gIoFVDPu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gIoFVDPu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781861143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zMlqmyyFgUF8NnVSUFxygt+NxV37HopokOxz2jLoL8w=;
	b=gIoFVDPuShC+TowlTk7SNeAaCvglboVO2jTbpOfij3QEVGuZdEWeszRG3/S3wdzoalK6uF
	/REEzBXiToFLIbZyEn2gOsLimSwRUv1RxqJAd0XNLipHilJzF67c6C0iqth0xHHzJdeZ91
	nkMsoOTVeB1b/7bMHoe8u6+7UBk8OV4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-SRX2vnCHOjOXGTdULzwoTg-1; Fri,
 19 Jun 2026 05:25:39 -0400
X-MC-Unique: SRX2vnCHOjOXGTdULzwoTg-1
X-Mimecast-MFC-AGG-ID: SRX2vnCHOjOXGTdULzwoTg_1781861137
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 44BE61955F26;
	Fri, 19 Jun 2026 09:25:37 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.4])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 528331956088;
	Fri, 19 Jun 2026 09:25:36 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id CF91921E6A01; Fri, 19 Jun 2026 11:25:33 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: qemu-devel@nongnu.org,  qemu-arm@nongnu.org,  kvmarm@lists.linux.dev,
  Eric Auger <eric.auger@redhat.com>,  Cornelia Huck <cohuck@redhat.com>,
  Peter Maydell <peter.maydell@linaro.org>,  Richard Henderson
 <richard.henderson@linaro.org>,  Marc Zyngier <maz@kernel.org>,  Oliver
 Upton <oliver.upton@linux.dev>,  Daniel P . =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Andrea Bolognani <abologna@redhat.com>,  Jiri
 Denemark <jdenemar@redhat.com>,  Gavin Shan <gshan@redhat.com>,  Shameer
 Kolothum <skolothumtho@nvidia.com>,  Sebastian Ott <sebott@redhat.com>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Jinqian Yang
 <yangjinqian1@huawei.com>,  Shaju Abraham <shaju.abraham@nutanix.com>,
  Mark Cave-Ayland <mark.caveayland@nutanix.com>
Subject: Re: [RFC PATCH v2 23/29] target/arm/qmp: add query-arm-cpu-props-info
In-Reply-To: <20260605083358.1320563-24-khushit.shah@nutanix.com> (Khushit
	Shah's message of "Fri, 5 Jun 2026 08:33:52 +0000")
References: <20260605083358.1320563-1-khushit.shah@nutanix.com>
	<20260605083358.1320563-24-khushit.shah@nutanix.com>
Date: Fri, 19 Jun 2026 11:25:33 +0200
Message-ID: <87o6h6hofm.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: K7GSK0FED6ju4CTYC3qKvJpZzn2czYYbbbfCRrHLGO0_1781861137
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Khushit Shah <khushit.shah@nutanix.com> writes:

> Introduce 'query-arm-cpu-props-info' QMP command. This command returns
> information about ARM CPU model properties, including their name, type,
> supported values on the given host, and composite parent if any.
>
> This provides management layer necessary information to determine
> migration compatibility off a VM on different host.
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  qapi/misc-arm.json              | 41 ++++++++++++++++
>  stubs/qmp-arm-gic.c             |  6 +++
>  target/arm/arm-cpu-props-stub.c | 13 +++++
>  target/arm/arm-cpu-props.c      | 85 +++++++++++++++++++++++++++++++++
>  target/arm/arm-cpu-props.h      |  5 ++
>  target/arm/arm-qmp-cmds.c       | 44 +++++++++++++++++
>  target/arm/cpu-idregs.c         | 71 +++++++++++++++++++++++++++
>  target/arm/cpu-idregs.h         |  8 ++++
>  8 files changed, 273 insertions(+)
>
> diff --git a/qapi/misc-arm.json b/qapi/misc-arm.json
> index 4dc66d00e5..1a3fb140c4 100644
> --- a/qapi/misc-arm.json
> +++ b/qapi/misc-arm.json
> @@ -46,6 +46,47 @@
>  ##
>  { 'command': 'query-gic-capabilities', 'returns': ['GICCapability'] }
>  
> +##
> +# @CpuPropInfo:

CpuPropertyInfo for consistency with type names such as ObjectPropertyInfo.

> +#
> +# Information about a specific ARM CPU model property.
> +#
> +# @name: the name of the property
> +#
> +# @type: the type of the property, any of ('string', 'boolean',
> +#     'number').
> +#
> +# @supported-values: the set of values the host hardware supports
> +#     for the property, a list of strings.

I figure the set of values depends on the host, i.e. it isn't known at
compile time.  Correct?

Are the possible property names known at compile time?

List of strings is fine when the values are strings.  When they're not,
the interface requires its users to parse strings, which is something we
try hard to avoid in QAPI/QMP.

> +#
> +# @composite: name of the encapsulating composite property if any.
> +#
> +# Since: 11.1
> +##
> +{ 'struct': 'CpuPropInfo',
> +  'data': { 'name': 'str',
> +            'type': 'str',
> +            'supported-values': 'any',

Description above claims "list of strings".  If that's accurate, it
should be ['str'] here.  Else, the description needs fixing.

> +            '*composite': 'str' } }
> +
> +##
> +# @query-arm-cpu-props-info:
> +#
> +# Returns information about most of ARM CPU named model properties.

Imperative mood, please: Return information ...

> +# This does not include composite properties or properties already
> +# defined by QEMU like (sveNNNN, pmu, etc), This only returns all
> +# the newly defined properties like ('feat_*', 'hw_prop_*', etc).

"newly defined" compared to what?

> +#
> +# With this upper management layers can find out what property values

Comma after this, I think.

> +# are supported on the given host.
> +#
> +# Requires KVM to be enabled.

What happens when it isn't?

> +#
> +# Since: 11.1
> +##
> +{ 'command': 'query-arm-cpu-props-info',
> +  'returns': ['CpuPropInfo'] }
> +
>  ##
>  # @SsidSizeMode:
>  #

[...]

