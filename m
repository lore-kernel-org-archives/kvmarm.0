Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0241514F2
	for <kvmarm@lists.linux.dev>; Fri,  3 May 2024 11:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714734206; cv=none; b=Cbr8DYS2thzuZGOgxykAU/HJQulSUHnv4pHHvOC2mUGWpmWOPi1fICZN2OrMI6SOS+dbqHICaKd7Vjcpsu6WzjMQ9BjtyGqp9HrAwJnn8SE6P8RZVxx1VK6qr1YLRse//w2SP4R2JaaYZ2VQZlF3V2VYj2WSmD+VIBpW2Z7aEqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714734206; c=relaxed/simple;
	bh=U8pbEeU6q3HFr1TucM82IKlHv9be5/rhk+jTB/vMHrQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XeiWVkXARRPI4f9H7oH2feGFyb5ycCAov0pn6bDyQf40JNiVJaWz0Fe33ZrmUouVxqM7RtEYu+eJUGJrswHcM1AhsPGOHdhgAIGzyaP3nLbPJ8KHrd8DPj8MpU6WSl5ix3BhmzchCyq49IvjPKIsr1PheZ8So8qw8MP7be/jLnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CRDce8aZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CRDce8aZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714734203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U8pbEeU6q3HFr1TucM82IKlHv9be5/rhk+jTB/vMHrQ=;
	b=CRDce8aZvls2/hukFKeRFntbNHSnf9VWNK29/N6rIK6EfYSJAvnTHFGswmffKFU9u8Pz7e
	SMW+H+Y1yeC85KrwLTqsOjLY7pEL50gWvHc0bxw0P7GMKsULZ97gcV7dNvKjIG1U4FHx/g
	7mYH0dtNlElft3vy0rxf5HcfutApfo8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-fuHzDj2HNSKKzhNSt6kmgQ-1; Fri, 03 May 2024 07:03:21 -0400
X-MC-Unique: fuHzDj2HNSKKzhNSt6kmgQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6a0e2c337bfso41761236d6.1
        for <kvmarm@lists.linux.dev>; Fri, 03 May 2024 04:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714734201; x=1715339001;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U8pbEeU6q3HFr1TucM82IKlHv9be5/rhk+jTB/vMHrQ=;
        b=Q7VdY3apsg0fmf/OWtSJe3mpPjHUs+zgh5iTiYuYUpEufA150tyGCwHNCgofPFRHch
         Y6O4HGcFCZX09aJUvNQU2k75Ayb7jvngxhISwIipnbKY1lX+BI7xhywQtXlAod25XXdF
         wOYPbx4sciEYF+A1yrxTm4hwMLG2kviBwiUL8sYIYiviLrf3hWlqpDAUoSbz7Uo5P+SB
         Oj8h/lJE/a7tvDIfU42+YjFkxqTKWUHsuFhrNl4MHFL+wWeEwBIekTd4jZuKxCtnoNGc
         3SZAEseR/BOoASp/eGIuXm34h5duUcqZo3YZxcSfu8Qc8g83UsoKp2TVdcxwrv/FSEWp
         zntg==
X-Forwarded-Encrypted: i=1; AJvYcCWJ3sVcILWJGyUPNmQyWCX8RCPiTClAgTDg0g4f3qIn+XHL8/VAdKbI7X5H89h7lAHifbL38X4sHb4SrTsvWx8k60S6rI7q
X-Gm-Message-State: AOJu0YxsADOeTH+YyKfbSBZJvC/SSSte0qG1aBdoVZCubj6sdVu6KyE5
	UuoTRzi14CG19+/QMQO+BVnm8zgZbLfYhNeUo/2S3jjOua9vvP9QBrl1tmq1ilr5i/YHeLHodjV
	w3D9ZoNQn913mO0XInMSi721FUgvNY5diSmauYgXSNHDbNDCh7TlHMQ==
X-Received: by 2002:a05:6214:20ea:b0:6a0:b507:9be2 with SMTP id 10-20020a05621420ea00b006a0b5079be2mr2172152qvk.38.1714734200719;
        Fri, 03 May 2024 04:03:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9Y4yhIMgz3JvEeyI3wePqNUPZGn7oPAlntaf8m61AG7y4+NXlBKBUHbSvQZE8Oga+ZVXwcA==
X-Received: by 2002:a05:6214:20ea:b0:6a0:b507:9be2 with SMTP id 10-20020a05621420ea00b006a0b5079be2mr2172136qvk.38.1714734200390;
        Fri, 03 May 2024 04:03:20 -0700 (PDT)
Received: from rh (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id m15-20020ad44a0f000000b006a0e0e93aa7sm1107669qvz.57.2024.05.03.04.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 04:03:20 -0700 (PDT)
Date: Fri, 3 May 2024 13:03:15 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 5/6] KVM: arm64: show writable masks for feature
 registers
In-Reply-To: <ZjHv14-GBafptt-m@linux.dev>
Message-ID: <eee2b0c4-2245-15d4-b887-122e080813e9@redhat.com>
References: <20240426104950.7382-1-sebott@redhat.com> <20240426104950.7382-6-sebott@redhat.com> <ZjHv14-GBafptt-m@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 1 May 2024, Oliver Upton wrote:

> On Fri, Apr 26, 2024 at 12:49:49PM +0200, Sebastian Ott wrote:
>> Instead of using ~0UL provide the actual writable mask for
>> non-id feature registers in the output of the
>> KVM_ARM_GET_REG_WRITABLE_MASKS ioctl.
>
> Urgh, yeah in retrospect I think we should've constrained this to the
> registers KVM considers "id regs" (the space occupied by known registers
> or otherwise RAZ).
>
>> Explicitely set the mask for CLIDR_EL1 to make sure we present
>> the same value to userspace than before.
>
> typo: explicitly
>
> Also, we know the set of mutable bits for CLIDR_EL1 as it is handled in
> set_clidr(). The mask really should match that, since the UAPI is
> documented as "allowing userspace to know what fields can be changed for
> the system register"

Done for the next revision.

Thanks,
Sebastian

