Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8A1C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 07:50:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D1544B102;
	Thu,  9 Dec 2021 02:50:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NkenTYkEcKrw; Thu,  9 Dec 2021 02:50:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F27A24B104;
	Thu,  9 Dec 2021 02:50:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A30F84B102
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 02:50:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xc7ofTHcMpzz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Dec 2021 02:50:11 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 684DB4B0BD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 02:50:11 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639036211;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=/AygQgJSDL/0VPHQil7DxyO7LMzsaDLMXqw5yWmd50s=;
 b=LnqVbwx+G1OX31NZmcCzIt86lXfRPnHQF5vFC8h/ip+ni8LooZBI0wujWV33l4EnQERrDy
 pH9FiVB9iiQ6z/9dJ+V054j1YAM6JpIOtLqEPb2/wc7ctjdI1EfvrEMKzxI1O3OyLGotpY
 zyzY7QSh3o6wn9wfZh9lo0qCy9Si+sE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-mLbKCzV4OImtB-zL-SWuzQ-1; Thu, 09 Dec 2021 02:50:08 -0500
X-MC-Unique: mLbKCzV4OImtB-zL-SWuzQ-1
Received: by mail-wm1-f70.google.com with SMTP id
 i131-20020a1c3b89000000b00337f92384e0so4446887wma.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Dec 2021 23:50:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=/AygQgJSDL/0VPHQil7DxyO7LMzsaDLMXqw5yWmd50s=;
 b=3MpUEIcL0L4NGuEZJGGiAx29uFmIyKVPR/4zlbPHrGnkrQsJT9nJC0MJnOFzyI2W+3
 xs3TMH1QS7f3FIKwiIcbdxbakk1YnJXk46ne2evntvKuzMINU22AjW/HJkRLchKVi/e2
 nPjjleRTtz/3G+mdmWkdichYcYiA0AVBIk6psbFQUBqaSkFssMSWJuu3Yclz2SYE6b9M
 votjqAz+2SsabxRLI5kGKxOJmCcK4jKB6wkqNq0JEEIVzbodK/1MkPywugTeMAoGt8SZ
 xB/URiQF6sMtJ6swxsebTvFXlVUII6ZgGwH/5L4NmSpuAdWBthoSOAt/3+JXCP4+6zJK
 4FWg==
X-Gm-Message-State: AOAM533lRHFw4bBQD/2Lyh95Odo3P2sawkfcaRL64aSfdenC8SKvvHwd
 1WrjwnBKGLFMr+Mo3mCoO9O2Bz/LszQGK3pHAy/ZfLQ1wG/BeAtIB+yWtIjrURm6smDQkID2V3k
 ZJlf82gWAlhKFmQwwmhejvN1L
X-Received: by 2002:a5d:68c1:: with SMTP id p1mr4404846wrw.585.1639036207479; 
 Wed, 08 Dec 2021 23:50:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxM7es35fO3bx5eEMf/Nb497G7NrF+/56L4RejjxGuiXbl8ZtgmWYluATX5InHERKthnvKkg==
X-Received: by 2002:a5d:68c1:: with SMTP id p1mr4404796wrw.585.1639036207210; 
 Wed, 08 Dec 2021 23:50:07 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id l5sm6766694wrs.59.2021.12.08.23.50.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 08 Dec 2021 23:50:06 -0800 (PST)
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
To: Jason Gunthorpe <jgg@nvidia.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com> <YbDpZ0pf7XeZcc7z@myrica>
 <20211208183102.GD6385@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <b576084b-482f-bcb7-35a6-d786dbb305e1@redhat.com>
Date: Thu, 9 Dec 2021 08:50:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211208183102.GD6385@nvidia.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kevin.tian@intel.com, lushenming@huawei.com, robin.murphy@arm.com,
 ashok.raj@intel.com, kvm@vger.kernel.org, wangxingang5@huawei.com,
 maz@kernel.org, Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
 iommu@lists.linux-foundation.org, vsethi@nvidia.com, vivek.gautam@arm.com,
 alex.williamson@redhat.com, zhangfei.gao@linaro.org, eric.auger.pro@gmail.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 Lu Baolu <baolu.lu@linux.intel.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Jason,

On 12/8/21 7:31 PM, Jason Gunthorpe wrote:
> On Wed, Dec 08, 2021 at 05:20:39PM +0000, Jean-Philippe Brucker wrote:
>> On Wed, Dec 08, 2021 at 08:56:16AM -0400, Jason Gunthorpe wrote:
>>> From a progress perspective I would like to start with simple 'page
>>> tables in userspace', ie no PASID in this step.
>>>
>>> 'page tables in userspace' means an iommufd ioctl to create an
>>> iommu_domain where the IOMMU HW is directly travesering a
>>> device-specific page table structure in user space memory. All the HW
>>> today implements this by using another iommu_domain to allow the IOMMU
>>> HW DMA access to user memory - ie nesting or multi-stage or whatever.
>>>
>>> This would come along with some ioctls to invalidate the IOTLB.
>>>
>>> I'm imagining this step as a iommu_group->op->create_user_domain()
>>> driver callback which will create a new kind of domain with
>>> domain-unique ops. Ie map/unmap related should all be NULL as those
>>> are impossible operations.
>>>
>>> From there the usual struct device (ie RID) attach/detatch stuff needs
>>> to take care of routing DMAs to this iommu_domain.
>>>
>>> Step two would be to add the ability for an iommufd using driver to
>>> request that a RID&PASID is connected to an iommu_domain. This
>>> connection can be requested for any kind of iommu_domain, kernel owned
>>> or user owned.
>>>
>>> I don't quite have an answer how exactly the SMMUv3 vs Intel
>>> difference in PASID routing should be resolved.
>> In SMMUv3 the user pgd is always stored in the PASID table (actually
>> called "context descriptor table" but I want to avoid confusion with
>> the VT-d "context table"). And to access the PASID table, the SMMUv3 first
>> translate its GPA into a PA using the stage-2 page table. For userspace to
>> pass individual pgds to the kernel, as opposed to passing whole PASID
>> tables, the host kernel needs to reserve GPA space and map it in stage-2,
>> so it can store the PASID table in there. Userspace manages GPA space.
> It is what I thought.. So in the SMMUv3 spec the STE is completely in
> kernel memory, but it points to an S1ContextPtr that must be an IPA if
> the "stage 1 translation tables" are IPA. Only via S1ContextPtr can we
> decode the substream?
Yes that's correct. S1ContextPtr is the IPA of the L1 Context Descriptor
Table which is then indexed by substreamID.

>
> So in SMMUv3 land we don't really ever talk about PASID, we have a
> 'user page table' that is bound to an entire RID and *all* PASIDs.
in ARM terminology substreamID matches the PASID and this is what
indexes the L1 Context Descriptor Table.

>
> While Intel would have a 'user page table' that is only bound to a RID
> & PASID
>
> Certianly it is not a difference we can hide from userspace.
>  
>> This would be easy for a single pgd. In this case the PASID table has a
>> single entry and userspace could just pass one GPA page during
>> registration. However it isn't easily generalized to full PASID support,
>> because managing a multi-level PASID table will require runtime GPA
>> allocation, and that API is awkward. That's why we opted for "attach PASID
>> table" operation rather than "attach page table" (back then the choice was
>> easy since VT-d used the same concept).
> I think the entire context descriptor table should be in userspace,
> and filled in by userspace, as part of the userspace page table.

In ARM nested mode the L1 Context Descriptor Table is fully managed by
the guest and the userspace only needs to trap its S1ContextPtr and pass
it to the host.
>
> The kernel API should accept the S1ContextPtr IPA and all the parts of
> the STE that relate to the defining the layout of what the S1Context
> points to an thats it.
Yes that's exactly what is done currently. At config time the host must
trap guest STE changes (format and S1ContextPtr) and "incorporate" those
changes into the stage2 related STE information. The STE is owned by the
host kernel as it contains the stage2 information (S2TTB).

In
https://developer.arm.com/documentation/ihi0070/latest
(ARM_IHI_0070_D_b_System_Memory_Management_Unit_Architecture_Specification.pdf)
Synthetic diagrams can be found in 3.3.2 StreamIDs to Context
Descriptors. They give the global view.

Note this series only coped with a single CD in the Context Descriptor
Table.

Thanks

Eric
>
> We should have another mode where the kernel owns everything, and the
> S1ContexPtr is a PA with Stage 2 bypassed.
>
> That part is fine, the more open question is what does the driver
> interface look like when userspace tell something like vfio-pci to
> connect to this thing. At some level the attaching device needs to
> authorize iommufd to take the entire PASID table and RID.
>
> Specifically we cannot use this thing with a mdev, while the Intel
> version of a userspace page table can be.
>
> Maybe that is just some 'allow whole device' flag in an API
>
> Jason
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
