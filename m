Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1EB36E498
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 06:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785825963; cv=none; b=al+qozd0YhXCEEoVEEpJvNSnZ6O053zsFI6inXwmw+Zpos73CvNND2w9v7QuiAzqHvlb2sZ7Gg48yM0Q0vFOkReWcM9mxKmyTtHPwi3L96C4qEnsNjyH0Kl0zNGfZE8CpY9/wHAdIj0cq1K2iS6Ih3l2kt/ypC64yvlKbnCfNtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785825963; c=relaxed/simple;
	bh=Drw3DEtoh0jJrNSb6k28XkWszIy+b8jHV4xZiKXVVsU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OSvYa9i7HP0JadMLs3TfwCMjMkV3Fv4yoUkbW21U7N+OuG7I6oFHJjS14EfqWlxODhRIw8ksgQ2BGtxQyJy1OcnbrpHWLdFvOVOXFplQOow5Ov1zzeQ5FPywFqCTWSmhZF6ujymcleT50q9zxUGCvakAn4aWYx9jeRFK3OBz0pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MpBZgyLa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MpBZgyLa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785825960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Til7dJ+LBxYd932gQSxYw4R3kFQ/CW4QMe0aradBus=;
	b=MpBZgyLa4EiBQ4k255ZrYhe9h6P14Eb/DAb49Eh/GCNsEpq7tAld34FzOXettWcjn2mBi2
	dnrdR311L3ZBUXYm6enusF2JDmetN7aymJ8CivZgx6MMS8k/+1OL3yGnSpYCoGgI+H/GaI
	0Ffvt0hnLRLuktQxlEHXR2LauHnDGxY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-247-SV9xW_IvNheFpOtuyKHrYA-1; Tue,
 04 Aug 2026 02:45:57 -0400
X-MC-Unique: SV9xW_IvNheFpOtuyKHrYA-1
X-Mimecast-MFC-AGG-ID: SV9xW_IvNheFpOtuyKHrYA_1785825955
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 408171956048;
	Tue,  4 Aug 2026 06:45:54 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.7])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51EB641C;
	Tue,  4 Aug 2026 06:45:53 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id BEBB521E6920; Tue, 04 Aug 2026 08:45:50 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: qemu-devel@nongnu.org,  qemu-arm@nongnu.org,  kvmarm@lists.linux.dev,
  eric.auger@redhat.com,  cohuck@redhat.com,  peter.maydell@linaro.org,
  richard.henderson@linaro.org,  maz@kernel.org,  oliver.upton@linux.dev,
  berrange@redhat.com,  abologna@redhat.com,  jdenemar@redhat.com,
  gshan@redhat.com,  skolothumtho@nvidia.com,  sebott@redhat.com,
  philmd@linaro.org,  yangjinqian1@huawei.com,  shaju.abraham@nutanix.com,
  mark.caveayland@nutanix.com,  prerna.saxena@nutanix.com
Subject: Re: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
In-Reply-To: <20260716213858.609699-17-khushit.shah@nutanix.com> (Khushit
	Shah's message of "Thu, 16 Jul 2026 21:38:55 +0000")
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
	<20260716213858.609699-17-khushit.shah@nutanix.com>
Date: Tue, 04 Aug 2026 08:45:50 +0200
Message-ID: <878q6m5qox.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: VDw-cy4bmcu33S1CGY8Hsv2Ajw6vVEXpQnfoOKSAF_k_1785825955
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Khushit Shah <khushit.shah@nutanix.com> writes:

> Introduce the 'query-cpu-props-info' QMP command. For CPU model
> properties it reports the type (boolean or number) and the set of values
> supported under the active accelerator and host.
>
> For numbers the supported values are expressed as a list of inclusive
> {min, max} ranges; for booleans as the list of allowed true/false
> values.
>
> The command and its return types (CpuPropertyType, CpuPropertyInfo and
> friends) are defined in qapi/machine.json rather than an Arm-specific
> schema, since the concept applies to other targets (e.g. x86, riscv)
> too. Target that do not implement it return an error.
>
> The Arm/KVM implementation spins up a scratch "host" vCPU object,
> walks its QOM properties: SYSREG_ ID-register fields become 'number'
> properties whose ranges come from arm_field_get_supported_values(),
> and the advertised feature toggles become 'boolean' properties.
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>

This explains what the command does and how it's implemented.  It's
silent on the most important aspect: why do we want the command?  What
is its intended purpose?

