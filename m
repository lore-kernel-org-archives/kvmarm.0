Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA362BEC37
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 10:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745921123; cv=none; b=bd5p1LzVmEHeqpJkogA/kuFUFBriqifiwT9pUL/Y+TZFy4MgKbK0VYZ+/G5Ix3KaBzcB6etkat28BXXG6KhzKCy6HidzL+Nh+svw4tdwDsJTeYrcK8rvANEOYJsWRGXCn2sDkz7XKCqLJ2UQps0IaSpb5FldY/214T+Unx2eAYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745921123; c=relaxed/simple;
	bh=y5NLyC1kw2O3SwbJo3iBwg72l0WjQvkHhB9h33OsuH4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SIM+fCCd93NzSNqjPVNeyKy5NOysBL9NxMBiDrCAIxVLIPV7M7oYntCN85ohcXIps8Z1dILTwX1cnhCBFAbvQkPSBaLKZ5aURkAs8Di7wXHDGsZlsK3itR61EsQtZfPEWKfyK/ixryRwHOzlcoxSVORku4sOf8vvnXIlCLjrdrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gbwcc/gZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gbwcc/gZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745921120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y5NLyC1kw2O3SwbJo3iBwg72l0WjQvkHhB9h33OsuH4=;
	b=Gbwcc/gZFpnFmtuNp12EkeW5hA9T01KRMY1e8IaD20f369oYx+IvMggk8ji/z5fQSVFp0o
	BIEnD24nYINgeImJbVhvrRbQalHGKZ8I8XXJltBzJvnvFX/iA6JrLYOn2+dt55cED11HBg
	EKfPdzP/smrdedjIr67+rR4YGwPwDkI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-529-fPgnIaV_PFyAjTEEO3J8mg-1; Tue,
 29 Apr 2025 06:05:17 -0400
X-MC-Unique: fPgnIaV_PFyAjTEEO3J8mg-1
X-Mimecast-MFC-AGG-ID: fPgnIaV_PFyAjTEEO3J8mg_1745921115
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3CE31956088;
	Tue, 29 Apr 2025 10:05:14 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7EDE195608D;
	Tue, 29 Apr 2025 10:05:13 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [PATCH for-10.1 v5 00/13] arm: rework id register storage
In-Reply-To: <4cbaa46b-2114-49b3-8d59-e92a4967665b@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250409144304.912325-1-cohuck@redhat.com>
 <4cbaa46b-2114-49b3-8d59-e92a4967665b@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 29 Apr 2025 12:05:11 +0200
Message-ID: <87cycvqo4o.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Apr 28 2025, Eric Auger <eric.auger@redhat.com> wrote:

> Hi Connie,
>
> On 4/9/25 4:42 PM, Cornelia Huck wrote:
>> Just a quick respin to fix a missed conversion in hvf.c.
>>
>> Also available at
>> https://gitlab.com/cohuck/qemu/-/commits/arm-rework-idreg-storage-v5
>
> I reviewed it again - I can't send any R-b through since I am co-author
> ;-) - and I spotted few conversion mistakes (I am most probably the one
> to blame here sorry)

Oh, I think I'm perfectly capable of messing up on my own :)

>
> Once those fixed, I think we should be good.

Thanks for the review, I fixed things up and did fdarray[2] -> fd for
the few cases remaining at the end. Will probably repost after some
testing.

