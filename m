Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9321734E75A
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 08:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786697153; cv=none; b=I8GXKF8uLq2SS+Nl2hXwXGCfczNJ4gTz4m907tUmkhPNxV/KkHm3S3olLU6bmfdPzvri905m8PsjlXZqpblv21siCXW7a9E8OmMMgwqiWhcQ3j7NslawVVw/2H39Yset7eN7LQDXmVupx7CT6msNJLu5KIQAF8CZRbwzEOM1gtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786697153; c=relaxed/simple;
	bh=i1c8AJsS/6BsMSz6FYSuta5r13xz+bKehed37J4V0no=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cPTej+ke87Ht9IECxQMg4Qa6KzZ3Y47LcuWpdJZ7t0gaoUUKstIukNhhsrXhP8Jfpdwigpv+pM0zhBl5cC8b6BFEjBHC4xmEmryOmlrtGEKkxe8AJADAc3t/KKLIOxEm4EoJtKX82RZKMmVpUoBYvJyxTP6drdxqQiIdsxUXw/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ADAGnN/k; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=a/WSt/jx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ADAGnN/k";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="a/WSt/jx"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67E7fb2r2166391
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 08:45:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=EVIasMr6ok/pt36pC50hDKA8
	cdlBEv5jazPUbRxQ61M=; b=ADAGnN/knxZwKwlqppLvR3DFXAywgoljCOl+bDim
	5OT8g8p1fI+jfG4Tv7QmaNjNoeROItyK5SqhEbWTo+zwlTjzwWTP3rVzs7ks7eIY
	a9/wsuMj/CE+x6BLqTjGCH8HL1HkoDlnDzR10GS+cDQhgoiRg3jkBzXjfZSAJ8kG
	+fjd4JynOdTTM2sRCQ1iC9vxldRXmga4ert1Llf1Nf4q2HqFf6ttwkmJ21iRqLLv
	+Bv1jYNq+LORKb8xk1UyJBCgl4rnQTu0k4KEDFcJ70xHPUngeLqlZrjkMMvD0PbN
	dCCT9KOOgCVVZF9bS+tojskYCm9xmevmrwLRAEJpHfgm3g==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g1j2nk520-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 08:45:51 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbedc1899f7so464294a12.2
        for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 01:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786697151; x=1787301951; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EVIasMr6ok/pt36pC50hDKA8cdlBEv5jazPUbRxQ61M=;
        b=a/WSt/jxhu8dOT/J+Jx4JEn5kbT2Ed+kTtE3z7jtk6NwsU9tEJ5tumx+N13GSyulH3
         jbK4ehuFHi9HbQ9S6RQippHQJnqbvnt5tD8SRIE591FSzCRRpSOxGwPcFzQi0fo7Ofhl
         6itwWVJCkbTw1RuJLSBDUpP5ToQBwev6Gbc2O3v0sTT3Z63XLUDELewcl+S0xqR/YxeY
         xsWpHiYwtroGDT4pMfujOVq81eoQyoBZgSEGjJg5yI9xfY3Tqkei/1QpgZoD/g7Fv34+
         7BC2joMtXyn0AQR1/cqjQlzhoGb1ZCjG5nArUcY7rQKsLZ6xeAuwIq4K35DOU9se++4c
         feqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786697151; x=1787301951;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EVIasMr6ok/pt36pC50hDKA8cdlBEv5jazPUbRxQ61M=;
        b=ntGgVV0QnZnbPM/XdMstfbiiGJ9Aa32Kj+qeTK+JRRSHnSgFcFT0m+LqefnYhSPclS
         n66OYsfll3rrgbK9to+4dWPwGZyuvay+678+w+69TLGOW2Yd3Um+/fanDbllCJ4sP3lC
         aZDbo7Sw4LaNK8TRpLajucHMNelUQezcjG9XqTNgUH9INm6gBWrJxKTAta+oE650oNYq
         3b05NfzyZYLdlnEhjdRnw7i7E4GqT+0p9YvMYvS5uoJ/euoikDvBeOD8IvE9tjjlpnBX
         WmcP0VEpMexb2fUJWL90LnVQ6CcnFy9lcOtSXe9UuYnzQvJNpExWvHhwuscmTcwpSHYC
         Q3VQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr9BG3qRbJZXkJ0MkEb1i3qxkMoPTiozZOBy9vGVTK5/NJGM6OZDEPwdVr26NwjF8UPvA4hym8=@lists.linux.dev
X-Gm-Message-State: AOJu0YygsjuLkJotm3dxqPmiK4az+kzT4mk73On8XKUzz+81K6+ee8Im
	DNt0281eiv6brr+gXJMzj3fRognuvZkigKgX8MSABCMa/LIv4YALDFT1rV12HVCJ4aajMQ05EiK
	FjfK0UJrQdPbOqI4VdRXFnof1gWQtROeHGm/i97dIdq2Phu1xlDTWMuLtc3M=
X-Gm-Gg: AR+sD13HtcSl+t3BK6tbOt8bVkJGbi3WwVpL0PuqyUWbuHc14wo5s1PR4UHd0VOOz6e
	+ExV6u0UaDpxdoNjHohpo/dHFMs8GsLlYcWJuYotm6zEVMNacXj9y5qPBpRR52qOmwLYEiRmGAB
	HVZ88Alxtn/oaoJaZXgrakWLfsx18tqJjC+jZETTYAqNu+Zb0LfFhO1d2MoO+VICmRNw8OOPIqD
	gBunyq30ahYgvjMFt3iHbaOEsf9DCumD0ZnhsIhYC6Uz1Jf53wWnumgnHdwYmHVWNQFuijh8qGa
	UINuHn3brrvcWwA/Q0MlHsLQPtj/GFH22ea/XtgVy+5pJYeg5KoQHR7w8St2ST+QGsEH/zUTQnm
	4ruH+ql6O/w3Lto3xKbFp3J7WvKeht74VUg==
X-Received: by 2002:a05:6a20:430d:b0:3c3:bbe6:95de with SMTP id adf61e73a8af0-3cc71d533c0mr4527079637.6.1786697150994;
        Fri, 14 Aug 2026 01:45:50 -0700 (PDT)
X-Received: by 2002:a05:6a20:430d:b0:3c3:bbe6:95de with SMTP id adf61e73a8af0-3cc71d533c0mr4527037637.6.1786697150586;
        Fri, 14 Aug 2026 01:45:50 -0700 (PDT)
Received: from hu-pkondeti-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320e9df03d4sm1808869eec.15.2026.08.14.01.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 01:45:50 -0700 (PDT)
Date: Fri, 14 Aug 2026 14:15:39 +0530
From: Pavan Kondeti <pavan.kondeti@oss.qualcomm.com>
To: Will Deacon <will@kernel.org>
Cc: Pavan Kondeti <pavan.kondeti@oss.qualcomm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
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
Message-ID: <5b557560-7664-4336-9e5f-86de8dcd6d90@quicinc.com>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-8-steven.price@arm.com>
 <ans1ZSwMEKeT9Gfz@arm.com>
 <d4bdecca-517a-4b4b-bf67-cef6b09bc8c1@arm.com>
 <7d4e5920-aa20-40cd-954e-037631bd0d6c@quicinc.com>
 <anx6YbPMVz3OlpA5@arm.com>
 <an2YN7kxB7bjCd2s@willie-the-truck>
 <8db602b8-7fd3-4c11-8fbd-3b8251648eb8@quicinc.com>
 <an3ihGk3znnk8TWV@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an3ihGk3znnk8TWV@willie-the-truck>
X-Authority-Analysis: v=2.4 cv=ApXeGu9P c=1 sm=1 tr=0 ts=6a7ed5bf cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=vggBfdFIAAAA:8 a=KKAkSRfTAAAA:8 a=oGdhJ8GHBgxCdCDN5qoA:9
 a=CjuIK1q_8ugA:10 a=_Vgx9l1VpLgwpw_dHYaR:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: QLBBtPOZMiPgLwUa0ER7SrdgiB17Fv7I
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDA2NiBTYWx0ZWRfX8vYfYEi9CsZU
 kjOochKkSEP3ume9lX2ZbpKR4Fa5hpy7eWRlz63PrZFXUeJCgqyT/QWD8roXQPL+LWXZ6dkivvX
 owwo1VWDvsfVF942FGtNtH7cgFzzpJg=
X-Proofpoint-GUID: QLBBtPOZMiPgLwUa0ER7SrdgiB17Fv7I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDA2NiBTYWx0ZWRfXyx2uS16LHUAX
 jTkCukebpCy/fZwlHKkhDGyBK+LWrRpkxjZHEBsd1Np5bja1iYhDdwLyZKbCmmom/0dUxpiUgGh
 jPLS51BrpxWJek+bpRtBkOIpKfsl6cgBP2V1WAn9HBVUsiX0hPZUB8lVGXRKdyYNe1xm7mGdKjY
 S/VdlR7pyQifx7XlXu/cxjLkc+BOXigoUTWoSju/yJSfjt+nvkJfRePq/n/jf2+VIeNjJCtotU/
 gD/35ET7cRglzPr7rzxjrR5CDIPtSJQPph2rJHjWYtJX+xtM+PBIv2sZZWWW60LsfUxgotfgbtS
 nbGreN2D1eG7why8u3CK4yhpTctnPPFnzaNf9tZwrjEP/Bv4jMq9X3lu5MY4C2eCTmLox2UNxKn
 uMgtJNy9rE65efBuYH/68XXoAynMDs1enUpfLciCdrdon+/w2l7gvtGPE5i++Q+/hIUuH38xMO5
 QNYonfQAk3N7c6x7VNA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_03,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 clxscore=1015 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608140066

On Thu, Aug 13, 2026 at 04:28:04PM +0100, Will Deacon wrote:
> On Thu, Aug 13, 2026 at 07:40:41PM +0530, Pavan Kondeti wrote:
> > On Thu, Aug 13, 2026 at 11:11:03AM +0100, Will Deacon wrote:
> > > On Wed, Aug 12, 2026 at 02:51:29PM +0100, Catalin Marinas wrote:
> > > > On Wed, Aug 12, 2026 at 06:12:09PM +0530, Pavan Kondeti wrote:
> > > > > There is a valid case for fixup_exception() to be needed here in GPF
> > > > > handling.
> > > > > 
> > > > > -000 |load_unaligned_zeropad(inline)
> > > > > -000 |hash_name(inline)
> > > > > -000 |link_path_walk()
> > > > > -001 |path_lookupat()
> > > > > -002 |filename_lookup()
> > > > > -003 |vfs_statx()
> > > > > -004 |vfs_fstatat()
> > > > > 
> > > > > We observed this in Android running Gunyah when the page is mapped in
> > > > > EL1 but unmapped at EL2. path_lookupat() can actually handle this
> > > > > via fixup_exeption() when a word load crosses the page boundary.
> > > > > However, Gunyah injects a Synchronous External Abort and we have
> > > > > a downstream patch [1] that adds fixup_exception() in do_sea(). pKVM
> > > > > injects [2] such faults back to EL1 and fixup_exception() is taken care.
> > > > 
> > > > Ah, good point, completely forgot about load_unaligned_zeropad(). Since
> > > > we don't unmap the linear map for delegated pages, we'll need the
> > > > fixup_exception(). And I guess warning in this case is not desirable
> > > > either. We could limit it to EX_TYPE_KACCESS_ERR_ZERO and
> > > > EX_TYPE_LOAD_UNALIGNED_ZEROPAD, though not sure it's worth it.
> > > 
> > > Alternatively, I think the series to unmap guest memory from the linear
> > > map would solve that for gmem:
> > > 
> > > https://lore.kernel.org/all/20260410151746.61150-1-kalyazin@amazon.com/
> > > 
> > 
> > Thanks Will for sharing this information.
> > 
> > There are use cases outside gmem like FF-A lend to Secure Partition.
> > we may not be enforcing all such memory to be unmapped at EL1, correct?
> 
> If you leave the cacheable linear alias of memory intact across an
> NS -> S transition, then you're in for a bad time [1].
> 
> Will
> 
> [1] https://lore.kernel.org/all/20221114110329.68413-1-manivannan.sadhasivam@linaro.org/

Thanks for the reply. In the above case, XPU does not like the speculative fetches. I am
not sure if there is a hard requirement for unmap of FF_A memory lent to secure
partition managed under Root with GPT.

Thanks,
Pavan
