Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015AE25C6E7
	for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 16:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751299392; cv=none; b=R7lOX4RNe3wtEUftdLKg40A1rWHIQoUkAtYfg3N9EC38RNkEvCahkNYdJwZKBMZVhxMNHCA+HTbXh0SqzKHYYLv0ay8OA8gGoyMsBlmDzelqIt/8OfH5VCaCjlB61Q8GFpjikRK6ozsyVgsB3UcdmRv+J5TuuLXhrjoFTahr/Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751299392; c=relaxed/simple;
	bh=536lL/PiKMJuSFzy3/JLNpZbEicga0Yq9x+lh5a1hxo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=K/1moQuzA3xddzYBugTZDJeIhTUGUFp9OIt0QJpt2lZVZ1NRma9ihlgKGd8zMhghH0tCzWuaHEVaJW/Bf3340kkMBdJJTINKdE1qsDVPtatuhKaqj7PRDLwBOt0W6FTJpiwltoam+hcMoO2eXBHZ4G9A54obTEFBW4SJqbNktcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QFcwScEo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QFcwScEo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751299389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RWPcrPt/aVAFUlzQoNuvD3ku+IQ0fPMZyUJg1YgZvTI=;
	b=QFcwScEorivFE4fnw+6kj8jFpB+hnYwtB+cQDOJ8LQhZdpdM5v1zL43dG4NP4qrqiVlrJb
	yY/EUgRXgibDnP4tJnARNAQoH1yft3ZQQ/K5H4rvTnyS7Gz64a5/kZCU54AZct/xEhabG3
	lbLdRYAHHASRSn3HJ9VX63RecudgJbY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-UOq3GucnMda1Cp-TsFcSTg-1; Mon,
 30 Jun 2025 12:03:06 -0400
X-MC-Unique: UOq3GucnMda1Cp-TsFcSTg-1
X-Mimecast-MFC-AGG-ID: UOq3GucnMda1Cp-TsFcSTg_1751299384
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA22218089B4;
	Mon, 30 Jun 2025 16:03:03 +0000 (UTC)
Received: from localhost (dhcp-192-236.str.redhat.com [10.33.192.236])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 009DD195609D;
	Mon, 30 Jun 2025 16:03:01 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com, agraf@csgraf.de, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v8 00/14] arm: rework id register storage
In-Reply-To: <CAFEAcA-Zuqzqg_qUQh+yT4BGqEke3=OhSr0iSY1ztPtVV506sw@mail.gmail.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250617153931.1330449-1-cohuck@redhat.com>
 <CAFEAcA-Zuqzqg_qUQh+yT4BGqEke3=OhSr0iSY1ztPtVV506sw@mail.gmail.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 30 Jun 2025 18:02:59 +0200
Message-ID: <87ecv1qkss.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Jun 30 2025, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Tue, 17 Jun 2025 at 16:39, Cornelia Huck <cohuck@redhat.com> wrote:
>>
>> Mostly addressed Peter's feedback:
>> - make sure every inbetween stage compiles (also fixed some bonus issues)
>> - try to make the scripts more robust, add a note the generated file,
>>   and make sure to grab only registers we actually want
>>   - I did a half-hearted attempt to use python instead of awk, but I'm
>>     out of my depth, especially with the script that will be used for
>>     the register fields in the cpu models series
>>
>> Also available at
>> https://gitlab.com/cohuck/qemu/-/commits/arm-rework-idreg-storage-v8
>
> The script seems to be creating array entries for some registers
> it should not still; I've left comments on that patch.

Hmn, will double-check.

>
> I've taken patches 1-11 and 14 into target-arm.next so you don't
> have to keep rebasing them.

Thanks!

