Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6142481649
	for <kvmarm@lists.linux.dev>; Thu, 13 Aug 2026 14:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786630256; cv=none; b=Moaw5HTq/yYKZtyvJwNK2lw/gfL2Ec389iDcm+3JDU3Ag7stzTLT0xGuukL2O8l2vwyQYIp+UqMkJyXRKcYKFzuKtgz6FPSmiO1J/X8vYYmgg4b4+q+Od181kASqXcs1eGzVkpbpGO+Bi4LB2dQAmno/5X6vgV3wpxydKMKXjh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786630256; c=relaxed/simple;
	bh=XPPQhlrE0bO8IfDnjPs/cSwx0flsvJaogoL5jJ9Sa9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qvRUnaTrS15oxFAC3KNHXjYbFfK+lP+kQNwNsK6bofZ7SOh58GI4QLh43oS3u09eAc1dJ5M4UGS2a7BzDDkIOV3Oty0IRL1/Q7AztHTXozem+ZZ3ttYpG/lO++0vqvUdJIbtjiM7cG4TU5FNIKLy8NVtWvDg6FHGFfbbXQl3czU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=F1pcNEgO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cGI5IxJX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="F1pcNEgO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cGI5IxJX"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67DCKmRZ2404935
	for <kvmarm@lists.linux.dev>; Thu, 13 Aug 2026 14:10:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=nnrhxChuvUvmnhUjftdL+cEY
	05K58EtTFKjpp0G3HSU=; b=F1pcNEgOoZ3yp0g3uucPc/lGIbIftg4yj93eVVG9
	G8Cygm5t09wMBysVSE1jAhc9qeIaD341KZ6skiYE1bu6JsYTZo51omzlUHy95+uq
	MoMH9vnOU3lwMQBNxRVVcs9Iuo3mpk+lRg4N9Q87INoIKyQfR9LVJpSoDYUyfF6Z
	CjrBiDuwKyLlSulMnczEQPzBn+aWtW6Tarv3FmBnNUwXEwpVA4g1zeIsZ2ltk9lh
	4tOcckJwORwstjwVy5QeYF5AWgQDjlGLYowb1HPMFOpCmRTbZHbUHui0y4hGqi5L
	9kQ9eHIEUZctP86420PdCrEbooubRFj8vhiS7WYeUxLgjA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g158gam9v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Thu, 13 Aug 2026 14:10:53 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cee894b3d8so14575105ad.2
        for <kvmarm@lists.linux.dev>; Thu, 13 Aug 2026 07:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786630252; x=1787235052; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nnrhxChuvUvmnhUjftdL+cEY05K58EtTFKjpp0G3HSU=;
        b=cGI5IxJXEnUt7DPXRlouWsD63SuR/CwW4tCJBgc7KmehPJHea6Dnb+yBbkxPR/jnEk
         JB/ZMOqlCKbnqPjHQj96+tcr+Y1ZfegSS9En7EG0WAnY1zQqKFkYtdq4ssqQKKgmqxwU
         MgMzmkyeHJtsGbHQ4PIaswuRrFgWB+OYeOYuVBd1QdUQAQQRv2/M8rmFt2B5PuzoDNNr
         1amJejRG6WZUu4lOALWDf75yXztCDDvgEYNBRwNfE/aWH3XWMF/Yz8qIX0xQL7HCDKo3
         yP9aWcjno2f6OHUROXcRpvP1L80wkkCzBsm3R1OpJavkqPP6P1u4AHNe7DoLPva2w1zb
         6kMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786630252; x=1787235052;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nnrhxChuvUvmnhUjftdL+cEY05K58EtTFKjpp0G3HSU=;
        b=UQ5A+aku1MHS1j0a6begrKubs9YAEKHWvnJWlSDb2iS5mOVQGhKz88hblThvjE4edS
         Xa/aTfvJb++vmm1F89W6QCF990a95K+bLHrpZ7WyYLjJu5h2/rO/2l80LDebJqCmnWwe
         nBwaKxpaC2Ef2uptITyYIN0YogX/xYic8/8tiugo5qbnyuLPVLLQBAPdC+6pJu8MxnPY
         k8TLQk1XGbEczbt49wOWi2wpSP5FaU83iEmI/rUJP897qLPW6ZMTlvIZC0L69j4c5V+x
         TI5JNXp7KhF0PRvk3hNlx+PLGYaLwoJZcSD84R7Vf3iY/jLVpwlD8GKv/tppyrSPANoN
         KEgw==
X-Forwarded-Encrypted: i=1; AHgh+RplBXergGRKVy8f1pARMlDdEUf23TONsufOTE1tJ8xSMkk/lwtplIBdfov8yxyBd3JWplB0sNg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzrpFEjIiUvxpvxP1XK3rLf4PISpRf6Yw2bhuYsXCFdI7XMUhjy
	yhScebYtYUBgjWb1YOjpXGqgEuySkI78KFPc3GN5z+fn6EtQUC9Sg64VFIM0qxaLyASK4xqT0X6
	E6EFomJ8Qpv2SEJEyWY+GyTCvXT8K7YqWxmdzYAFkBYWoktNZ2sSf4Bjci5g=
X-Gm-Gg: AR+sD13lpJR9OALdiFGXK89O1u65Vkvn3UyKwf5l+vshoQyU0xGwdXbXL2jTT1IaYPh
	FVZJIq36kRFaFuw4QKcWdGhlMgF16LZpesL3L2e1SY9JSJgrAVS+6yONeoL+ivZcGpiWesNUlJB
	gnuvA/T0l/4gtiak5QAdf1wcF7eJ8Y39njfWlKqsvd6eZmWMY9orv47XV07ETDXCfcpc0DDS7iH
	+biU7BdtjjJvUcfmDXrkfdIxfyB5G2elMo4GBZBFdpTYuDDad40TIH+E6jgf/EtEBP04+/i9xqZ
	lC+itO+AWvNW1h9WGDt3utxbCmP1iuBTeh5fKy8kkINJMkxcV0NeZLnB4+IIvbMExlpp6u5f3f+
	unENLFD8wDEqjIO+pFRhvEi/Vl8xD6T671Q==
X-Received: by 2002:a17:90b:4fc4:b0:38f:57f3:4dc6 with SMTP id 98e67ed59e1d1-3931e304a76mr7286848a91.21.1786630252113;
        Thu, 13 Aug 2026 07:10:52 -0700 (PDT)
X-Received: by 2002:a17:90b:4fc4:b0:38f:57f3:4dc6 with SMTP id 98e67ed59e1d1-3931e304a76mr7286722a91.21.1786630251469;
        Thu, 13 Aug 2026 07:10:51 -0700 (PDT)
Received: from hu-pkondeti-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ec082633fsm8518276eec.28.2026.08.13.07.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 07:10:51 -0700 (PDT)
Date: Thu, 13 Aug 2026 19:40:41 +0530
From: Pavan Kondeti <pavan.kondeti@oss.qualcomm.com>
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Pavan Kondeti <pavan.kondeti@oss.qualcomm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Gavin Shan <gshan@redhat.com>,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        Alper Gun <alpergun@google.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
        Emi Kisanuki <fj0570is@fujitsu.com>,
        Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
        Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v16 07/45] arm64: mm: Handle Granule Protection Faults
 (GPFs)
Message-ID: <8db602b8-7fd3-4c11-8fbd-3b8251648eb8@quicinc.com>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-8-steven.price@arm.com>
 <ans1ZSwMEKeT9Gfz@arm.com>
 <d4bdecca-517a-4b4b-bf67-cef6b09bc8c1@arm.com>
 <7d4e5920-aa20-40cd-954e-037631bd0d6c@quicinc.com>
 <anx6YbPMVz3OlpA5@arm.com>
 <an2YN7kxB7bjCd2s@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an2YN7kxB7bjCd2s@willie-the-truck>
X-Proofpoint-ORIG-GUID: jrKKwDGCWiiBvhbUj4Lf7wZEqjlJGHJp
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDEwMSBTYWx0ZWRfX6tzjp63bjiem
 xtzEw8b7+RSkj5qf2MKd3P7Kfq4B4yGJU1yjGyqsxKxN4d0Z876rMpfgT+GLR1SXZJjG3KN7zEM
 IzDkKgU6obwFSga3K9m16GnI3diiDOk=
X-Authority-Analysis: v=2.4 cv=G5ks1dk5 c=1 sm=1 tr=0 ts=6a7dd06d cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=vggBfdFIAAAA:8 a=dIWtD5pVMjQwIhOhhukA:9 a=CjuIK1q_8ugA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: jrKKwDGCWiiBvhbUj4Lf7wZEqjlJGHJp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDEwMSBTYWx0ZWRfXwBT6x2RU57tq
 UfypmrQ2jGUvC5DeKsIE84ZtmAWwcUXCypQY4czvqmVLViIAAUgz9Ckdjng0kSOQwyaxZtGkyNz
 q8dRpVmQ+9PXR6ElhfYwzAaWUjFO+m3Z06W2FHOaQWcRD3cg80piC9K6it4dXGPg2EYkMUfBN3l
 /ieuF223Ol0eXbnMOl29WRsMWeIRXx4otwcGeQnUBirz9zVUsnZFfa01ks3Xqzy1J1WW4/3Dzms
 vHC+f6AlUCOouM1eWMT4dQFQ5+kaPeVxHXxssFs6GFswvLuwbgiwcRi9WMgUHWkTaPngXN4D40v
 Ji6VF4pnST5V2m4SSdMe4m3ziSBM2JvT3BLYGZFXobx/39YKZkledSF63EpUm0otrRQz7WgGZAk
 yRpnqt25YHavDUyT80GGuRJm1rLStYFjsdDEp5+wqnwIq4GkUg/Chfy9Gwb2Ca6lhlUfQiCLvfC
 6Z5xNiyTjBXHOBYBbcw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608130101

On Thu, Aug 13, 2026 at 11:11:03AM +0100, Will Deacon wrote:
> On Wed, Aug 12, 2026 at 02:51:29PM +0100, Catalin Marinas wrote:
> > On Wed, Aug 12, 2026 at 06:12:09PM +0530, Pavan Kondeti wrote:
> > > There is a valid case for fixup_exception() to be needed here in GPF
> > > handling.
> > > 
> > > -000 |load_unaligned_zeropad(inline)
> > > -000 |hash_name(inline)
> > > -000 |link_path_walk()
> > > -001 |path_lookupat()
> > > -002 |filename_lookup()
> > > -003 |vfs_statx()
> > > -004 |vfs_fstatat()
> > > 
> > > We observed this in Android running Gunyah when the page is mapped in
> > > EL1 but unmapped at EL2. path_lookupat() can actually handle this
> > > via fixup_exeption() when a word load crosses the page boundary.
> > > However, Gunyah injects a Synchronous External Abort and we have
> > > a downstream patch [1] that adds fixup_exception() in do_sea(). pKVM
> > > injects [2] such faults back to EL1 and fixup_exception() is taken care.
> > 
> > Ah, good point, completely forgot about load_unaligned_zeropad(). Since
> > we don't unmap the linear map for delegated pages, we'll need the
> > fixup_exception(). And I guess warning in this case is not desirable
> > either. We could limit it to EX_TYPE_KACCESS_ERR_ZERO and
> > EX_TYPE_LOAD_UNALIGNED_ZEROPAD, though not sure it's worth it.
> 
> Alternatively, I think the series to unmap guest memory from the linear
> map would solve that for gmem:
> 
> https://lore.kernel.org/all/20260410151746.61150-1-kalyazin@amazon.com/
> 

Thanks Will for sharing this information.

There are use cases outside gmem like FF-A lend to Secure Partition.
we may not be enforcing all such memory to be unmapped at EL1, correct?

Thanks,
Pavan
