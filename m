Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A123E1205
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 06:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785913105; cv=none; b=c7+CXU3U4y1UlF9OSBUIu+CgHBOiWU9Bak+fxqfcxqaO+W76aJ6QN/7te1Vd65TNAVgUGHXvCm2aeGhPFhdBE4JujsTsCYequceQXPk/+D6EtCsReZNBMknDArn5CKC10MpS0YTBFs4AMM1keMxVfdnBAahwDesTEY+Z/v+A+BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785913105; c=relaxed/simple;
	bh=c0Glx7MMA1Z7Xc3V0ziMaF/kXbNUncpcxqT3DQaUhVU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fYyac9brBTNHGSNEdnAT80PxcXQwL3mdfE65qKb5qF0oLGkdOxKncOkKEjG4rkbi9qG4xjHcSFD88fyLKsyQfewZHAZL1a/2I9eWsfEYKmhVIUyY1fEoRQBbaX4nB8kZR5ey9EktDNvC7LFXhh7C6l/5MmQrxbMw3o2X94zNi7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eWD6SXQx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eWD6SXQx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785913101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DsV1CxCP2DFQNpD5SLyy63ooITBk+do3PIxT7xrCLRQ=;
	b=eWD6SXQxAuIDUYuAchpaT6iSQkSkCWeNbFyWHV02ld6PQV30fk6wqbQUQK6JPx6AdMsZ6h
	y0VjqhuWAhu7inbspR3r/rIdj2yxWX0TiFvau7KOnCZCpL2lqAGvrJy5Gn4TKdKzpMQRAv
	qd+HmDLX9g21OkNb0iGFzQWhRET97BU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-00q7SxgkMlijPMDT01eICg-1; Wed,
 05 Aug 2026 02:58:18 -0400
X-MC-Unique: 00q7SxgkMlijPMDT01eICg-1
X-Mimecast-MFC-AGG-ID: 00q7SxgkMlijPMDT01eICg_1785913096
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DCA719560AE;
	Wed,  5 Aug 2026 06:58:15 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.7])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC4EB180049F;
	Wed,  5 Aug 2026 06:58:14 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 547E221E6920; Wed, 05 Aug 2026 08:58:12 +0200 (CEST)
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
In-Reply-To: <08DA9B28-D5BD-4EC3-8182-FEE212F0C2A0@nutanix.com> (Khushit
	Shah's message of "Wed, 5 Aug 2026 06:48:20 +0000")
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
	<20260716213858.609699-17-khushit.shah@nutanix.com>
	<87y0f5u78t.fsf@pond.sub.org>
	<6AA3BD42-9596-476B-9F64-AB09372821B9@nutanix.com>
	<87tspa5skn.fsf@pond.sub.org>
	<FD805FA0-9323-450C-9D79-319C0883F05E@nutanix.com>
	<FDD5760F-94E6-46F4-AC62-AB0DC98322FD@nutanix.com>
	<8733wu5qfs.fsf@pond.sub.org>
	<08DA9B28-D5BD-4EC3-8182-FEE212F0C2A0@nutanix.com>
Date: Wed, 05 Aug 2026 08:58:12 +0200
Message-ID: <871pcd12bf.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: nmKwqUxOB3DSLA3NW_2hDcB4vQ88P-krSIyBdFeSGN0_1785913096
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Khushit Shah <khushit.shah@nutanix.com> writes:

>> On 4 Aug 2026, at 12:21=E2=80=AFPM, Markus Armbruster <armbru@redhat.com=
> wrote:
>>=20
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>=20
>> |-------------------------------------------------------------------!
>>=20
>> Khushit Shah <khushit.shah@nutanix.com> writes:
>>=20
>> [...]
>>=20
>>> Stub file was missing on arm user builds.=20
>>>=20
>>> I have fixed this on the private branch if you want to take a look.
>>=20
>> I'm willing to pull an update to v3, assuming it's a small fix.
>
> It is a small fix :)

Please tell me what to pull.  When you're ready, of course.

[...]

