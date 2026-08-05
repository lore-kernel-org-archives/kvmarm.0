Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB9D42AFB5
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 13:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785936168; cv=none; b=XQoz8NiM8sxgsaM2zNELKMMQmI6S099STApwBW65Zl3CnEckci1urqV4bkh2vDL9uVmSaVxmRgiL+VELC2dANYhwAhwF3QWblcCTWQvWW5XolDoioBzJJCBP/ms09qDcclhptfaR4AsTB3lsRGX7+c2kTdkkINPn91RTKrtk+Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785936168; c=relaxed/simple;
	bh=gRyum2V4LAzpUcdoNcXtRYZODXrwfTfUAhx+VDhnRwc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=uWRXwaOnKUpWTQMnV2Ule+q0EccVNp1WlN02d2OxVpEJjxIeAH0Uc7UVlNbnnTD0v048Lw7qRnlN1466D9GMKxuwzScsHV+TD+7kI+rXC6BXpaBJH1tynnem0zbG9+2n6wR7zbYFiJGAQeSzPO3jrMbmdGezMNDbMVeLvbezymk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fjmn1QPP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fjmn1QPP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785936166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9wi3XW+KFj9sTieUCiS9bErMSb8fpwD3DcBAKWHUuRY=;
	b=fjmn1QPPH6dWvu+HHXRm80Q6pXun1fjvRFO/ZPg8MeKChghXj8He4GfhNODW6rCsF7Y3w5
	7Qu1H/4VtCrqacbx6TMQSXDuVFT7R0UNNmzNo/Yve0ngSy7a0Ya97aWK/QODkhuHEeQ2YJ
	seqg9yN9jTKMwLEZ88+EzHm6G0m3k8w=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-141-jOKzqmDKNdSHZfzPXwKmpA-1; Wed,
 05 Aug 2026 09:22:44 -0400
X-MC-Unique: jOKzqmDKNdSHZfzPXwKmpA-1
X-Mimecast-MFC-AGG-ID: jOKzqmDKNdSHZfzPXwKmpA_1785936162
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1F731800646;
	Wed,  5 Aug 2026 13:22:41 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.7])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C1551956041;
	Wed,  5 Aug 2026 13:22:40 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 01FCF21E6920; Wed, 05 Aug 2026 15:22:37 +0200 (CEST)
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
In-Reply-To: <5F6481F1-B5E1-4B30-A4D1-481D9C0731AC@nutanix.com> (Khushit
	Shah's message of "Wed, 5 Aug 2026 07:32:10 +0000")
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
	<20260716213858.609699-17-khushit.shah@nutanix.com>
	<87y0f5u78t.fsf@pond.sub.org>
	<6AA3BD42-9596-476B-9F64-AB09372821B9@nutanix.com>
	<87tspa5skn.fsf@pond.sub.org>
	<FD805FA0-9323-450C-9D79-319C0883F05E@nutanix.com>
	<FDD5760F-94E6-46F4-AC62-AB0DC98322FD@nutanix.com>
	<8733wu5qfs.fsf@pond.sub.org>
	<08DA9B28-D5BD-4EC3-8182-FEE212F0C2A0@nutanix.com>
	<871pcd12bf.fsf@pond.sub.org>
	<5F6481F1-B5E1-4B30-A4D1-481D9C0731AC@nutanix.com>
Date: Wed, 05 Aug 2026 15:22:37 +0200
Message-ID: <87o6fgzopu.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: YVOO1pZcGzK0Q5Tkzi9EnDBWZ_V5Ni2BVedeeJol4rw_1785936162
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Khushit Shah <khushit.shah@nutanix.com> writes:

>> On 5 Aug 2026, at 12:28=E2=80=AFPM, Markus Armbruster <armbru@redhat.com=
> wrote:
>>=20
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>=20
>> |-------------------------------------------------------------------!
>>=20
>> Khushit Shah <khushit.shah@nutanix.com> writes:
>>=20
>>>> On 4 Aug 2026, at 12:21=E2=80=AFPM, Markus Armbruster <armbru@redhat.c=
om> wrote:
>>>>=20
>>>> !-------------------------------------------------------------------|
>>>> CAUTION: External Email
>>>>=20
>>>> |-------------------------------------------------------------------!
>>>>=20
>>>> Khushit Shah <khushit.shah@nutanix.com> writes:
>>>>=20
>>>> [...]
>>>>=20
>>>>> Stub file was missing on arm user builds.=20
>>>>>=20
>>>>> I have fixed this on the private branch if you want to take a look.
>>>>=20
>>>> I'm willing to pull an update to v3, assuming it's a small fix.
>>>=20
>>> It is a small fix :)
>>=20
>> Please tell me what to pull.  When you're ready, of course.
>
> It=E2=80=99s on the same private branch: https://github.com/khushit-shah-=
nx/qemu/tree/upstream-rfc-v3-fixups

Builds, but fails "make check" on my box *sigh*.

tests/qtest/qmp-cmd-test.c needs an update.

