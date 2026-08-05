Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E5A32E6BC
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 06:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785913055; cv=none; b=kLhC7k4V01glCt//CWbmG2zPHj49shnTsJVg9nteV6r6h66YbaTLYpyIxyoObmeEXB+oYt1N+iLV/sM9GmWo+oR1P2WVGQpkmVzz+E46trZertlb5PQiLK+cfHUn5eJsSgs2sg9qSrhLtxPlXAOSkV2ujugj7Un6w99kKwF6Oa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785913055; c=relaxed/simple;
	bh=DY+iH8leuDqYXPHssSd8pIGTH70nZ6AfzkTZ/x1t+oM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=oZQMUNeKRnsD42yfxv1N6FMrI/IQdQ992JUwF/PBqEo2OkhJH8zvYaxknS693F1US7+MuGqjCiMgJylF0xMLnx1iS7nf2NuXDAZx5IpY1ns+IV2zsCDvebTRVDd37uQ/nTkXRgpPH/aVAgpHD8K+WXnRoGUf7cW39m79J5xg60c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZoMFfpfJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZoMFfpfJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785913051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lj+eIYu+GnCTy6Ki1Nabxss2/9rRJooPZ3Uu0q/sdE4=;
	b=ZoMFfpfJzNmntaaYS2FwEdo0gJNtbW5QgWZ5aISOXGUCkGD/wI8Pa2h3tzkwBIJX0rncZt
	OZre1kaueL25+gsjuev5tkEinYWqji4SVSSNSD7WsdNl44oafmIOVcF2eAZSL4p98UNIti
	U3NnbHFHOv4g1UA4/MwgKUEjkB18EmQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-XnzXpwKLNGmgUgnka3LzkA-1; Wed,
 05 Aug 2026 02:57:27 -0400
X-MC-Unique: XnzXpwKLNGmgUgnka3LzkA-1
X-Mimecast-MFC-AGG-ID: XnzXpwKLNGmgUgnka3LzkA_1785913045
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E49801956095;
	Wed,  5 Aug 2026 06:57:23 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.7])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C914E18005A7;
	Wed,  5 Aug 2026 06:57:22 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 3DC5C21E6920; Wed, 05 Aug 2026 08:57:20 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,  "qemu-arm@nongnu.org"
 <qemu-arm@nongnu.org>,  "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
  "eric.auger@redhat.com" <eric.auger@redhat.com>,  "cohuck@redhat.com"
 <cohuck@redhat.com>,  "peter.maydell@linaro.org"
 <peter.maydell@linaro.org>,  "richard.henderson@linaro.org"
 <richard.henderson@linaro.org>,  "maz@kernel.org" <maz@kernel.org>,
  "oliver.upton@linux.dev" <oliver.upton@linux.dev>,  "berrange@redhat.com"
 <berrange@redhat.com>,  "abologna@redhat.com" <abologna@redhat.com>,
  "jdenemar@redhat.com" <jdenemar@redhat.com>,  "gshan@redhat.com"
 <gshan@redhat.com>,  "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
  "sebott@redhat.com" <sebott@redhat.com>,  "philmd@linaro.org"
 <philmd@linaro.org>,  "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
  Shaju Abraham <shaju.abraham@nutanix.com>,  Mark Cave-Ayland
 <mark.caveayland@nutanix.com>,  Prerna Saxena <prerna.saxena@nutanix.com>
Subject: Re: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
In-Reply-To: <3099C064-6051-4B93-BE0F-C54B7FD91D82@nutanix.com> (Khushit
	Shah's message of "Wed, 5 Aug 2026 06:47:52 +0000")
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
	<20260716213858.609699-17-khushit.shah@nutanix.com>
	<878q6m5qox.fsf@pond.sub.org>
	<3099C064-6051-4B93-BE0F-C54B7FD91D82@nutanix.com>
Date: Wed, 05 Aug 2026 08:57:20 +0200
Message-ID: <875x1p12cv.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 127.0.0.2
X-Mimecast-MFC-PROC-ID: suUxHB4j5hKRBT-IiulzNJnWjXBT5K1GCiG3FESjLVA_1785913045
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Khushit Shah <khushit.shah@nutanix.com> writes:

>> On 4 Aug 2026, at 12:15=E2=80=AFPM, Markus Armbruster <armbru@redhat.com=
> wrote:
>>=20
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>=20
>> |-------------------------------------------------------------------!
>>=20
>> Khushit Shah <khushit.shah@nutanix.com> writes:
>>=20
>>> Introduce the 'query-cpu-props-info' QMP command. For CPU model
>>> properties it reports the type (boolean or number) and the set of value=
s
>>> supported under the active accelerator and host.
>>>=20
>>> For numbers the supported values are expressed as a list of inclusive
>>> {min, max} ranges; for booleans as the list of allowed true/false
>>> values.
>>>=20
>>> The command and its return types (CpuPropertyType, CpuPropertyInfo and
>>> friends) are defined in qapi/machine.json rather than an Arm-specific
>>> schema, since the concept applies to other targets (e.g. x86, riscv)
>>> too. Target that do not implement it return an error.
>>>=20
>>> The Arm/KVM implementation spins up a scratch "host" vCPU object,
>>> walks its QOM properties: SYSREG_ ID-register fields become 'number'
>>> properties whose ranges come from arm_field_get_supported_values(),
>>> and the advertised feature toggles become 'boolean' properties.
>>>=20
>>> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
>>=20
>> This explains what the command does and how it's implemented.  It's
>> silent on the most important aspect: why do we want the command?  What
>> is its intended purpose?
>
> Will add something like:
>
> This helps the management stack to discover which values are supported
> for a given CPU property. This is especially important for non-boolean
> properties, where knowing that the host has value 'x' does not inherently
> reveal the full range of valid values supported on the host.

Better.  Perhaps throw in an example if you can come up with a simple
one.

