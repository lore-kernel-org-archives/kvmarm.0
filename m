Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7EB2BD004
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 15:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749742481; cv=none; b=nPml02YRXq1UkRL2tVVqpyQ6lIqF5IdAkZue9eAsRgjMaJmCokBSdZAXgurk6VIV8i8DrwJve9Vw6WCN+mIILc0rHZmrl6wCxndM9fTESiOfRAOs6j/6slqxeaybnAXqkieN+sY8GYnIA4kSqYp0f9Tp6Bq3hnuEHDd+JdHfiC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749742481; c=relaxed/simple;
	bh=PUt6jW+0YbqVKRq1vGu3eyen6i33GlcPDLpnOk4BvJk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hKVl0V0K7y14JooS5i9e6q/98GUiseB/ql2gtWuAoMHa1FL/nC8c9v3/BGrVQ9oeYMNQ1k+Qtn4GMb0/VUhzq59meK9lX1SWRnzh18hqGFPk8kEnpr1wxqqRxpPhwCfUs0/zDQQZu6ejzyuoBUhk0J/BGD9r2Xam/MPeZ483fuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QZIsp1Mp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QZIsp1Mp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749742478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zjWEWalRhjt+Jmg9fJ1nInmzuE3X/VWFJ2VSJWP1rn8=;
	b=QZIsp1MpPbzdtZkUTQBrJaboDm3U85z+eBiWd85yaWPCn+MtLXLBvf60dE7xtj0fyOMgPE
	6iuEdBSfH4xWtP1bBIXe2a83CNkQQWKi/cYGjBd2B4NB7ja9VGqu0kCnn3y6bjLj7W4T7F
	+oDYYzmtHTw+e08RHuPdSL2KcmXbqKA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-110-tRi18R-kMvCLwqUtRyyPkQ-1; Thu,
 12 Jun 2025 11:34:34 -0400
X-MC-Unique: tRi18R-kMvCLwqUtRyyPkQ-1
X-Mimecast-MFC-AGG-ID: tRi18R-kMvCLwqUtRyyPkQ_1749742471
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90A1E1801BD8;
	Thu, 12 Jun 2025 15:34:30 +0000 (UTC)
Received: from localhost (unknown [10.45.224.54])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D58B18003FC;
	Thu, 12 Jun 2025 15:34:27 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com, agraf@csgraf.de, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v7 02/14] arm/cpu: Store aa64isar0/aa64zfr0 into the
 idregs arrays
In-Reply-To: <CAFEAcA8y_wwZPoqkyPrNscRNTEwiOQm5Or9C=aiSNMGcZmq8CQ@mail.gmail.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250515153907.151174-1-cohuck@redhat.com>
 <20250515153907.151174-3-cohuck@redhat.com>
 <CAFEAcA8y_wwZPoqkyPrNscRNTEwiOQm5Or9C=aiSNMGcZmq8CQ@mail.gmail.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Thu, 12 Jun 2025 17:34:25 +0200
Message-ID: <87cyb99doe.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Thu, Jun 12 2025, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Thu, 15 May 2025 at 16:39, Cornelia Huck <cohuck@redhat.com> wrote:
>>
>> From: Eric Auger <eric.auger@redhat.com>
>>
>> Also add kvm accessors for storing host features into idregs.
>>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> Reviewed-by: Sebastian Ott <sebott@redhat.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>
>
>>      if (!cpu->has_neon && !cpu->has_vfp) {
>> -        uint64_t t;
>> +        unit64_t t;
>
> This doesn't compile :-)
>
> -- PMM

Hum... weird that my compile didn't hit it.

