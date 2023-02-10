Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125328808
	for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 22:03:15 +0000 (UTC)
Received: by mail-qt1-f174.google.com with SMTP id ch10so6361284qtb.11
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 14:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Id2+UsrVYKoKh+v2gTwy3GQbNktc9GS1SBwYfNKmfZk=;
        b=iqtd9Kec5IJph3ZTrG8aQ9XA8blKN8EHZeUno7ZWq0Z74T/ZFpvFUAI6XOOFsTmA+m
         rwX4VSVwFgKG8++rIsb1NW+uwc20/oMmEguoB1q+abQT6HtYJ8zcOy86uB+rZ8vVmRld
         2ONCeJrkJs+1bJKW5qNSOuxc0l3Dq+MJAP89YqTRGA3SLzYY2WI9GZ5/n1vyx8Hb9I6K
         g6dceqVSlv7QHhSyY3OjMwlusWa/Dq/WWiaDmeEmV9/JziIURezkSEHg6LZWQ0IvbAHe
         Wb8vXjAFl6FrlH8LF4jBZCY1SxXhNRje/gAIV0F5rBtBGYv4x3oZkaGae96O34RyiNO3
         gbjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Id2+UsrVYKoKh+v2gTwy3GQbNktc9GS1SBwYfNKmfZk=;
        b=LKXuY5qyfeXd/4A/zSWnmeZ5J/9CyrF7EJd38a0+f5r+1w2YPEGJhcu5a96GhUIlWE
         82w04HNKip3XzefHXQ9N0w8vVEIkOKoK4YNFQGVvbgEh1dpYC1FbcrOxU1+9+9cdPJy7
         rqtq3OJMMPCWnBrYCLcD6oW1foD6YgrbMTSrtcjxrX7F+rW2iwtYocHxyI+MvrmcN68x
         x0RFg4vHKq753Y3K1esKO2Kbz+g3jrgPqKii14B6juoBqMlm2dz71eRJCNmCtzzlSAap
         0bMrmwjRnum9XQbD/P1mpxhgRV2G1jAuqMIEBdGufs6mM6gDBeZtrlPzcZU+1ah59ySp
         lk9Q==
X-Gm-Message-State: AO0yUKVz/lEUOQNGKjoQBTEcBXEvZOY+09wpIPCZNiHUKdKd79NLvZbR
	xov5Yp4npNIkK3SlDZJUQE5Zj2gAX0hPeEWda5jz5g==
X-Google-Smtp-Source: AK7set+a2IupuOe1iheQ8otTvVtY3AqFS2GYaIMQsbCA6aSlPzZqYmefbzH5B1fbTNFe1V6Vb61IH3YUyWK6KZqlu0U=
X-Received: by 2002:ac8:584e:0:b0:3ba:1f09:94b5 with SMTP id
 h14-20020ac8584e000000b003ba1f0994b5mr2106266qth.358.1676066593926; Fri, 10
 Feb 2023 14:03:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-20-jean-philippe@linaro.org> <Y+JOhEfi8mu1RuOt@google.com>
 <CAFgf54q+R6nQBUAz9Quj8pQiTgKe7R_7BdQ=PWWay0WqDVzL1Q@mail.gmail.com> <Y+PkUKe72Q2WJGlp@myrica>
In-Reply-To: <Y+PkUKe72Q2WJGlp@myrica>
From: Mostafa Saleh <smostafa@google.com>
Date: Fri, 10 Feb 2023 22:03:03 +0000
Message-ID: <CAFgf54r6r8n6wYQqHuCqeuTiOp4h0PehR4yFaJLa0cchAbRTtw@mail.gmail.com>
Subject: Re: [RFC PATCH 19/45] KVM: arm64: iommu: Add domains
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org, joro@8bytes.org, 
	robin.murphy@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, yuzenghui@huawei.com, dbrazdil@google.com, 
	ryan.roberts@arm.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 8, 2023 at 6:05 PM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> On Wed, Feb 08, 2023 at 12:31:15PM +0000, Mostafa Saleh wrote:
> > On Tue, Feb 7, 2023 at 1:13 PM Mostafa Saleh <smostafa@google.com> wrot=
e:
> >
> > > I was wondering about the need for pre-allocation of the domain array=
.
> > >
> > > An alternative way I see:
> > > - We don=E2=80=99t pre-allocate any domain.
> > >
> > > - When the EL1 driver has a request to domain_alloc, it will allocate
> > > both kernel(iommu_domain) and hypervisor domains(kvm_hyp_iommu_domain=
).
> > >
> > > - In __pkvm_host_iommu_alloc_domain, it will take over the hyp struct
> > > from the kernel (via donation).
>
> That also requires an entire page for each domain no?  I guess this domai=
n
> table would only be worse in memory use if we have fewer than 2 domains,
> since it costs one page for the root table, and then stores 256 domains
> per leaf page.

Yes, that would require a page for a domain also, which is inefficient.

> What I've been trying to avoid with this table is introducing a malloc in
> the hypervisor, but we might have to bite the bullet eventually (although
> with a malloc, access will probably worse than O(1)).

An alternative approach,

1- At SMMU init, it will alloc va range which is not backed by any memory
(via pkvm_alloc_private_va_range) that is contiguous with the max size
of domains.
2- This will be like a large array indexed by domain id, and it would
be filled on demand
from memcache.
3-alloc_domain will make sure that the new domain_id has a page and
then any other
access from map and unmap would just index this memory.

This can save the extra page in the root table, handle_to_domain would
slightly be
more efficient.
But this can cause page faults in EL2 if domain_id was not correct (allocat=
ed in
EL2 before). So I am not sure if it is worth it.


Thanks,
Mostafa
