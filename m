Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A7D6F312
	for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 06:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721285913; cv=none; b=CbR6Ccb/2xIJSJFD52yPQcl91/cpv+QB5U7e7ZwTU3DBhXcNJrlas/yB/I89gq/QAlu/Sl40MWdCHryFX8g0hGMjHKrgjumXDJn305V7dbbJxi8Uujxo65OS2ZglQDINmH6hqUC6QKK20gsDZwRJeJCMKmKuUtE3ShythUKSlzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721285913; c=relaxed/simple;
	bh=Kqn6cTrmfIzgkIx3WEH8VYDiK/t68yBsPcxpcm9FGG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pngK9CVQunv39eKIsZczdbxZ8h9I3MqMBtjdeDhwteqkgyyGXFKCRyg30yoQe0svJSIqhnnWCryTCYPx5vmoDNs+VNLnemyeLAjuYDLylSpOZiPfX9K7/fYwijQznXWSgNkl6ojE19dTepIErDkvBNDuCufmjH3oOedRu54D7d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lm+doEwh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lm+doEwh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721285911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I+K3lMJtnJCRQkaiGsSYsWcq1BscDhBThSdy8hI3z6g=;
	b=Lm+doEwhgwLI+hv0xXOkBDyc4pOlizg0oNSba8FgA2fst+S6UDs+Aq82wGhncY7rH4hJPM
	Y8v0BwKsP6Lz5PbEIXoykatw33raMui8XEQlkOnif7oQA94RnrTbLu2Tm7A4ggl+pbbR1T
	iiUUHixIQbvr67YzRv4vAnw4FicSnN8=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-hLB0YYkiPLOOxfWKw7C0aw-1; Thu, 18 Jul 2024 02:58:27 -0400
X-MC-Unique: hLB0YYkiPLOOxfWKw7C0aw-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-804deff330aso12666939f.2
        for <kvmarm@lists.linux.dev>; Wed, 17 Jul 2024 23:58:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721285907; x=1721890707;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I+K3lMJtnJCRQkaiGsSYsWcq1BscDhBThSdy8hI3z6g=;
        b=hbx22Ulz/5dtq664M1B3jb6uMgVzE67wRXg4dOYi44xtIlTxKmrpE0Ylej3nXX0e2k
         ijrsQLbeFzDWPvyzcjyYs+bGw6N9we9xiwWo8Lvr1hhnfWDox+zvwrg9e1cMb+vMq4XC
         xW14BCnJ740ZCDKcmqnSWT2Vfm7Vupk4uJNTkUIfZpBoL3Pyczn3pxOUVicCknpHzSyi
         sWJ9gX1mSzKW7QReMSpFgpyLgU8U3+db0rl9MOufvU3U2wVI9JIPqgUPVF9LGl0IGE0N
         NIw/solBiKPG+5Vbiv5viXQ3Li45ECQ/cznNingj1+nb1F7PGiPC2jvk3kDuGHT07YS4
         Mz1w==
X-Forwarded-Encrypted: i=1; AJvYcCWkmmxERvlTcRHAZOvdHrA3R9Lne9oiW7941eCBSv2H9aw7NIhgHq6wOzZEhXYWQkFhrG1E5y1mGN2Rdonh01B3fwPLzwQK
X-Gm-Message-State: AOJu0Yw5+4VRkpJzqmyeOuhQ8Q2/qzB7+LtFN0xC38ti0O5neuDTfFq2
	4uPRrotRVC+/ojqlKMbxHWaLurIIraXpsjjJN8ODAxXj3+D2edZAv6TWJ0ygwNDAQcEr5/aAC+j
	fh7rQf5sPYxsn21YT9QK/cOf3QbuPLOJ1E0ofIhZ8LoBqoxkfToShOA==
X-Received: by 2002:a05:6602:6e81:b0:80a:4582:cef1 with SMTP id ca18e2360f4ac-817125e2e78mr282664339f.3.1721285906777;
        Wed, 17 Jul 2024 23:58:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1CUDdb/pqONt4Je62LN6f3jGYm7SmTlakN/c+RI3Vxcjrt9NAAPcskLboMdbw0D7ZJe4dZQ==
X-Received: by 2002:a05:6602:6e81:b0:80a:4582:cef1 with SMTP id ca18e2360f4ac-817125e2e78mr282663039f.3.1721285906340;
        Wed, 17 Jul 2024 23:58:26 -0700 (PDT)
Received: from [10.72.116.35] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b7eb9e26fsm9201874b3a.21.2024.07.17.23.58.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 23:58:25 -0700 (PDT)
Message-ID: <817b5f2b-ec69-4a66-ad7b-ea8c8b9d0f24@redhat.com>
Date: Thu, 18 Jul 2024 14:58:20 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] KVM: arm64: Disable fields that KVM doesn't know
 how to handle in ID_AA64PFR1_EL1
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Mark Brown <broonie@kernel.org>, Eric Auger <eauger@redhat.com>,
 Sebastian Ott <sebott@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20240718035017.434996-1-shahuang@redhat.com>
 <20240718035017.434996-2-shahuang@redhat.com> <ZpixhBjsqhWTpEQH@linux.dev>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <ZpixhBjsqhWTpEQH@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 7/18/24 14:09, Oliver Upton wrote:
> Hi Shaoqin,
> 
> On Wed, Jul 17, 2024 at 11:50:14PM -0400, Shaoqin Huang wrote:
>> For some of the fields in the ID_AA64PFR1_EL1 register, KVM doesn't know
>> how to handle them right now. So explicitly disable them in the register
>> accessor, then those fields value will be masked to 0 even if on the
>> hardware the field value is 1.
> 
> It is probably important to note that the only reason this is safe to do
> from a UAPI POV is that read_sanitised_ftr_reg() doesn't yet return a
> nonzero value for any of these fields.

(Reply again by the plain text)

Yeah. That would be more clear if I tell the reader this information. 
Will add this when updating.

Thanks,
Shaoqin

> 

-- 
Shaoqin

