Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5717123B0
	for <kvmarm@lists.linux.dev>; Thu, 19 Oct 2023 10:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hvh6moc+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697712337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nZU5n3KTDTfUWmADsG196A6CHko6IR01XuC7O+Kf4xw=;
	b=Hvh6moc+LfQVJzHc7AgxVfGWFY1xHN0lR98Fl9kJsPQMI/JiAW4JawLXsK/W/K6g0SSFoj
	i5z9pJQ/J+yFm77jk9ZVjjN/XgSuqV84Zro2h8eJ81EgGtt3jnqNakXXfa2ym4dbPRlzlG
	8WyVX+wsj04Q1gU5P8zf4qJtV9tU/7I=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-rBN1xh0GONudPKMzZZWHNw-1; Thu, 19 Oct 2023 06:45:35 -0400
X-MC-Unique: rBN1xh0GONudPKMzZZWHNw-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-7ab4118be99so2024096241.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Oct 2023 03:45:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697712335; x=1698317135;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lxd5MODsmAGKbTuOienYvfNws4TA5AoutDP3QGe6tEs=;
        b=MdyPurANqBzWSZOHlUCPuNLnySIuAm03Q0dPEoDER/vPEsBgmCBM58l38WcQEQmUr6
         Mx8BYDxy+orBg9Y+Deek2s6BVmgL8hS6WBSnjn4zTR8SDYUIVzg2+ChmaxaOS8Fa2+HH
         JnKUzy6jWsYKXaRVFUL6F21jqWIXeyvBXMuCBn9VM8/tWYJjWw7OAA8OnF0PinH5LRdb
         BPiRLc7lyj3UGQ9EuGKLCgj/EBjVu+2mnBTdd4AXXIB+OGcWg5rMNf0Njd5TgII2oa1O
         hLXnfmYKFJHu2RdgXNauaJjRXCn1ksNx0O1CvGiQtjx/hcUWqtWFkKqncXj4XThU7wsv
         PDcw==
X-Gm-Message-State: AOJu0YzjkQIOrXfmuRLHQvOgEhHmmWL0ciayx135SHscGRJFE8y/WLyu
	Dl5SiQgH1okMw6mBlj/bWinvYySk0eRycp/fgn47S3nscHCB8i55CNJfFW6By46wjyVE3EkN/Nv
	f8yDHASNiq0FfnopC
X-Received: by 2002:a67:b702:0:b0:44e:ac98:c65d with SMTP id h2-20020a67b702000000b0044eac98c65dmr1269385vsf.27.1697712335132;
        Thu, 19 Oct 2023 03:45:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYky3whGsAgdNN+wxhIzNqJbdy0LW6MrG6Q0VPEs7UbfeSBAf1GMlgRpft6IJk9K4PeYFSrA==
X-Received: by 2002:a67:b702:0:b0:44e:ac98:c65d with SMTP id h2-20020a67b702000000b0044eac98c65dmr1269373vsf.27.1697712334816;
        Thu, 19 Oct 2023 03:45:34 -0700 (PDT)
Received: from rh (p200300c93f0047001ec25c15da4a4a7b.dip0.t-ipconnect.de. [2003:c9:3f00:4700:1ec2:5c15:da4a:4a7b])
        by smtp.gmail.com with ESMTPSA id em17-20020ad44f91000000b0064f43efc844sm687385qvb.32.2023.10.19.03.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Oct 2023 03:45:34 -0700 (PDT)
Date: Thu, 19 Oct 2023 12:45:30 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
    Alexandru Elisei <alexandru.elisei@arm.com>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
    Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
    Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
In-Reply-To: <CAJHc60z7U1-irTy-6URb_V0PTW+TYS4qodf2akSg33_7CJgjyw@mail.gmail.com>
Message-ID: <f7cd9b3d-c817-7082-d60a-a529e1c82f1e@redhat.com>
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-9-rananta@google.com> <5d35c9f3-455e-6aa9-fd6a-4433cf70803a@redhat.com> <CAJHc60z7U1-irTy-6URb_V0PTW+TYS4qodf2akSg33_7CJgjyw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463795790-1917350782-1697712334=:15494"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463795790-1917350782-1697712334=:15494
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 17 Oct 2023, Raghavendra Rao Ananta wrote:
> On Tue, Oct 17, 2023 at 8:52 AM Sebastian Ott <sebott@redhat.com> wrote:
>>
>> On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
>>> +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
>>> +                 u64 val)
>>> +{
>>> +     struct kvm *kvm = vcpu->kvm;
>>> +     u64 new_n, mutable_mask;
>>> +
>>> +     mutex_lock(&kvm->arch.config_lock);
>>> +
>>> +     /*
>>> +      * Make PMCR immutable once the VM has started running, but do
>>> +      * not return an error (-EBUSY) to meet the existing expectations.
>>> +      */
>>
>> Why should we mention which error we're _not_ returning?
>>
> Oh, it's not to break the existing userspace expectations. Before this
> series, any 'write' from userspace was possible. Returning -EBUSY all
> of a sudden might tamper with this expectation.

Yes I get that part. What I've meant is why specifically mention -EBUSY?
You're also not returning -EFAULT nor -EINVAL.

/*
  * Make PMCR immutable once the VM has started running, but do
  * not return an error to meet the existing expectations.
  */
IMHO provides the same info to the reader and is less confusing

Sebastian
---1463795790-1917350782-1697712334=:15494--

