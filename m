Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C13642A94
	for <kvmarm@lists.linux.dev>; Fri, 21 Mar 2025 15:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742569531; cv=none; b=O9WqKtYseD/kpRBy7t5gwOV7iwGRIAAD7yRLeKBtV7e+FVxsj4NLxgTewfNvff+dofAOrQ7M18+Irak56nLwsRKrxle0hHqDdr7qosFy4fnVXN7JqyAEWbFdTXBwrU2BYhttbbot8rmZtu+ifo6yXwCBWv3DT+eWKO/9DSsG8AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742569531; c=relaxed/simple;
	bh=IfRmgRl0xoQ6wXn78HVnBxfM2bC8e91S0S+5O0nvG5M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gUbk63uf9EA9zAW8mCbVIvbEZ+uz03eyed4/Vg4BuC+0J/zdoPQLgUmE4WS2bUbf7ph5SaizC91vyOzQrK22U2Zkv0kEG4tqKIUmGepgW556bpDnMUaWa1a9HBnnzb2LA1DeLv2oJl1XN1LxMD1uO51zWPv6xyu13E8m7qWNUvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WR5UjkfQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WR5UjkfQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742569528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5R+ajQwnCzOTnEk7/Bcr1/crlPPyRTCprYEV/8jk2A8=;
	b=WR5UjkfQE/ayQEXSY7NV0YoL3jLhd0Uzr4i0ua2svf3NWZtK3wStFACdEzDNhhZyOM4QH4
	r8PUuxC+rY/eQ/lzPCMDl/0bA5YlYAf5VPu5JXUajrv8R+2yimvOIgzC8Wv//LbIvaczCg
	Rekn8QGcGTvvPklWJg//7Umca/sW8Dw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-LzjtJHa7P2S4k7YUT17pWg-1; Fri,
 21 Mar 2025 11:05:24 -0400
X-MC-Unique: LzjtJHa7P2S4k7YUT17pWg-1
X-Mimecast-MFC-AGG-ID: LzjtJHa7P2S4k7YUT17pWg_1742569522
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CC06180AF6C;
	Fri, 21 Mar 2025 15:05:21 +0000 (UTC)
Received: from localhost (unknown [10.67.24.51])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 158E81828A83;
	Fri, 21 Mar 2025 15:05:18 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
 philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 00/14] arm: rework id register storage
In-Reply-To: <86plino2ru.wl-maz@kernel.org>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250311162824.199721-1-cohuck@redhat.com>
 <86plino2ru.wl-maz@kernel.org>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 21 Mar 2025 16:05:12 +0100
Message-ID: <871puqv2zb.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Mar 11 2025, Marc Zyngier <maz@kernel.org> wrote:

> On Tue, 11 Mar 2025 16:28:10 +0000,
> Cornelia Huck <cohuck@redhat.com> wrote:
>> 
>>   - I'm open to changing the source of the definitions from the sysregs
>>     file to the JSON definitions published by Arm; however, I first wanted
>>     to get the code using it right -- we can switch out the code generating
>>     the file to use a different source easily later on, and I'd also like
>>     to steal parts of the script from Linux once integrated (which I think
>>     hasn't happened yet?)
>
> I don't think there is a real appetite to have that script merged in
> the kernel. My current plan is to maintain it separately.
>
> But by any mean, take it and do whatever you want with it.

Thanks for the info; I'll look at it again once the rest of this series
here is done.

