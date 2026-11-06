Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.135.74
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793985490;
	b=YodtiLeLhd0BOIHIyuM/Rr65HCle6ePpzs0wefanSIzeV6BD6ScEwLT5VNvKYxMhWvIV
	 VA9SCHGFAQNLYlLs00zBqNiIfQ7K1c8WBa2jzmGbaTLXEvdi+W/dtitgQYIcX24tUMABA
	 ZOGMBS0K3asd9z+NzhM1AJrguqcNM8i5AyNyyONub8fz2tRSA3jy+CkKZuev8ROhuHF5X
	 8rbGa3/AnfWrw0UTUtHw/QSsbH384NYdE/9xVbaxpGWUPXLi6AgX1J+IOxZbzlsJV8S9D
	 A8yFHJCryaorjktNVLJQPbSU4GEd5CKcO8CiBj1W9XfkWMYP/HX+7Rugjgff0C62Pvg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793985490;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=T59m8WXKnLMZksH0X3OIVWtfvJ0HewjqtyBEFa8ziT4=;
	b=kzWKTeRE/sOWH2wuDRxXKWiTQu0nJv+XqffRKCM5pKzUuIqJIM55cdvtZDhZLqSCuOQd
	 8h7wMK1LLMgWgIrQXxIsfaXC1gIOYhlT3L+Zt+VBqZzWNKIaP+2zCfk05PY5bL1hpg6EE
	 GkuPfbBOjOAK0W+rUl6II3Ibudqtdq7nOvuID+h5hgAV6H+FFY+ZX5wdfu/QycOv48RKi
	 ctBIjzYXVJSwLpd5nDWdXZdstGZ38BkhmXnovj7gp5DYO5BK2gFi87R99V4t1Vdv1DrnI
	 qFi58fp5tVsxi81BRE0zTY/JT2IYvPH0vQAzGhlN3nx5twRmc2cs7RNyLcyLrmevv4g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=kHuByDj0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45575606A339
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 17:18:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45575606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=kHuByDj0
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6Fh5ka2167501
	for <kvmarm@lists.linux.dev>; Fri, 6 Nov 2026 12:18:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps01; bh=T59m8WXKnLMZksH0X3OIVWtfvJ0H
	ewjqtyBEFa8ziT4=; b=kHuByDj0/YKHgTsrNhhmedA/FP7mqZGT62dRvXg9HauW
	gMDXV8u3jnw8J/ppSffjbBmhjR9FkIx0Xom/frHFEyHtVSi1goB/BSTlcqSchrXC
	6jMvdcldqNdUbPu4DAvgWToTSzCJIPBYi+yPI8++eJ8IRtKJHiwN1Y6gWUIte5lF
	BfJHkIRFyabKynbxbjYeeY9H/1oBQzjRcLJPSH0t2CufgkrzCB7oIsjcrnSYipOG
	QclCid9TTrSlHujzXSwdlDiU+Lm9V/LvMw49Na9FygTqG/Bx3dvgIbTx6lYXwR7W
	GHipks+eota340S1R1pnBuF0brvaw4Af8cV6C2dwvg==
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hs3pdd2wm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 12:18:08 -0500 (EST)
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-8b12b209c4dso9214097b3.2
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 09:18:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793985487; cv=none;
        d=google.com; s=arc-20260327;
        b=FQXWGOGQ7U5e1Wi6UtM9bjmMBe7QKhUuGLIebO3CX0gX9KENuSzrKdDIYf0o3n2tGI
         vqoYVyoN7ah4G8pX6qs9mvHBqBvoKPiANlYMHZQL6T22stIUWW3XoSW2N4TeukbxJLPw
         HxDODnThyF/WA1Rop4TmUJXsRG8tAfwHkwHbL7fuRYys/SuTNc4tY383wptVLcfq/CqP
         lBCILx3NnpZQ6wMG7NmHQPWwxsz/J1kz1SGHDL2hju5gmlKPdjff3TP0ULMbafVimqiK
         Zf7yMm8kAeLGPQ8/xqLZZ9vHjAlkR+F5GFw8WBbzgCPpLVM/76H4gQe63xXzLKByGklt
         dDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=T59m8WXKnLMZksH0X3OIVWtfvJ0HewjqtyBEFa8ziT4=;
        fh=ZeJWMfXociS4zFa58W1qywW2VS0QZ5mXhO6SVXb1v64=;
        b=nt/U2YydFDyy43faIfaTi7/01z2VQDHB7kdJhyYmhLMu3ony+xu17JNCU/tLM+UGcU
         +0udiWvYm4ccQ5NoH//5OIS5B9pgfTvslwSkfPOBBjCE6tYxSF7o00fAoXdthLMhnkMT
         VmRroGNkOpwD267dmXJjX9l3Mu1KScfgpungfUFiYhjW8Nlzpdqhe1wpBu9peRZmtK/R
         z9RJIFnrPoACvl5bAFKClFUlS8beWL1N87nEKNGxeKxpEcanYT/HzzYZ6Rn9a4WENZK7
         5548QOEWsjoyi8sMmxBiFfNuhQnf7QHGNC7m0AVwAQc07FFXjRE7QDHGVRQPjTjHOmKS
         bMcA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793985487; x=1794590287;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=T59m8WXKnLMZksH0X3OIVWtfvJ0HewjqtyBEFa8ziT4=;
        b=Wza9kLNGdKaYlCf5VAcJIumnmB/X1ykzMalIzBvjWNNoLY/IgPZEFEEytKlBadQj5I
         kA2rkvzKRW1hGE0VXP0xe7kOOCTB03gfQkkIfISvIPXLIMykHgJasI6Ov3u1TdXPrd71
         TNXm8hR/V7iG50zURgyYBj9ZnjNrJkFlWkDuSy4HXKBkN1xTCQnW9EsADtpRKhh5YypK
         naPk2RK/Muui15oTsduFfR/LjB4mBtF/O0BK6mj5/HFXpEz6XMOz679eiJnBVH9vVLFc
         uRSz4gQbWRix8h7E8Vunlqtm+UAyEfY6TuX64GlQ/TLN0JceGZi2MBKU9++J7rOHJQu+
         lnTw==
X-Forwarded-Encrypted: i=1; AL+hErGfvKpZYZkkg50Bd2MlWf2u3qhoD791EjTTwIMvx2QoEv2BgXtC4/fCPkIa2f8vO34KaMzJ+iU=@lists.linux.dev
X-Gm-Message-State: APuU4Z90SQaez4eQw6lA8VoaAeFOuB/2T0Cqy1/dg2v9GGDMtSkrRwtS
	OZAqMo6hDQ1tvO77V6Da0RyVfba80LLKIcHPKHMZYiNdhHvhc0EddlD7CyR6tazbEBsLQv0tIbo
	jYmBdOO2bC6yKz8A2SvlPx4/Uiax+Qm4bBJq+Db43rj5BNP06z4nFi9xPx4yklyVNHKBZwNvJud
	u6XhGNeVLKtNMBCkJqPaUMc1st5heu
X-Gm-Gg: AYBFou3RvYZbpd4kRbD2MNtZIAOMjrjcmm/6QRkwm8sxcjaPOzif1kBy3c+lZa0cc0b
	Fcqt51u89TtEkubqfyCwSbwKT1WuMBZY1mrivm38d7O04MIKx3/1LnzYaBuNUm621tN8z33m+Wo
	RoOXsuUsLQyUmRM5Jd5SpfibNIpSt5tsqf8tkrnIef5HVpQGR0WMC2AxBKon4g5mZbhXSKHCpsM
	lvB/yhSV778TCyZJ0A3+lwzB0xFrFjwP2GlajefNIYUyaMB8faDRTXQyFey0PCbn/edLJjBgShK
	hB+8lynlGgcvANoEvP8DXeyhHQ++xp4npw==
X-Received: by 2002:a05:690c:38b:b0:8a9:e801:231c with SMTP id 00721157ae682-8b3418de960mr15159357b3.20.1793985487309;
        Fri, 06 Nov 2026 09:18:07 -0800 (PST)
X-Received: by 2002:a05:690c:38b:b0:8a9:e801:231c with SMTP id
 00721157ae682-8b3418de960mr15159067b3.20.1793985486807; Fri, 06 Nov 2026
 09:18:06 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261105-hyp-pool-and-map-v2-0-44a6ca90190b@cs.columbia.edu>
 <20261105-hyp-pool-and-map-v2-3-44a6ca90190b@cs.columbia.edu>
 <CA+EHjTx-X_2DaO6Yt-AHsP55SFWjz_EYxEr-TB9WSN-ZT+d3FQ@mail.gmail.com>
 <CAPOPQMB6eU0MYNewcq8HKsEMchwY-X3aT0Km9uULBappFWZcjQ@mail.gmail.com> <CA+EHjTz-R016BwhcptZ3xVQe+a8C7au6ZL8jwZANdTf=cXRZHQ@mail.gmail.com>
In-Reply-To: <CA+EHjTz-R016BwhcptZ3xVQe+a8C7au6ZL8jwZANdTf=cXRZHQ@mail.gmail.com>
From: Xuheng Li <xuheng@cs.columbia.edu>
Date: Fri, 6 Nov 2026 17:17:54 +0000
X-Gm-Features: AclHuK_9svrT6wKNkNHEsIMr6l5W7zWgD8S3IUtPesXe8MFok8Z1sXe3kPtMyT8
Message-ID: <CAPOPQMCQfYWRDRvo4PPFW0RAyqNmns6TqS+QYE3-5SM_NFRMQQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Don't replace a valid hyp block
 mapping with a table
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>,
        Steffen Eiden <seiden@linux.ibm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vdonnefort@google.com
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-GUID: f37hN0StRnZeBM4fLTwkELHewzoLYESR
X-Proofpoint-ORIG-GUID: f37hN0StRnZeBM4fLTwkELHewzoLYESR
X-Authority-Analysis: v=2.4 cv=auUnmiZV c=1 sm=1 tr=0 ts=6aee0bd0 cx=c_pps
 a=g1v0Z557R90hA0UpD/5Yag==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=uYC8CqauRjbKsmU2jI4A:9 a=QEXdDO2ut3YA:10 a=MFSWADHSvvjO3QEy5MdX:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDA2OCBTYWx0ZWRfX5PCB/3bQsjYq
 rNwuW0DyIlI+RerhKCbFRyjD+7gfee65aU0CzisTP+UqoBZwtG71JnKAh5K0ORVZ0ZOVGQDa7aI
 gVltbcRaPk0rTUlNOQYCmYiyYbWftocnNsONfo5PE0zqrocSIPTx565EhTYP2OKzDvDpraVcvXL
 8P6zCrQ/IObQ1qjCUD1Jjv6ENY1RFr8u4Z6Sd2AXPrhfHFvpYB6Tc2Rp32ybD8EtCC/xWbl4HaK
 NJpOxpHtTau+LvguKbFnhNR8WU3ZscoapQZWeicHqzAOaspyoT/xJ+HkHjIGYrM1IMo10LBUbBJ
 +bry6pRtLz49vLbJ29bEvdwk1bH9jnh5cn4r1oevjx8FWBFUk2nNC+vK3/W2ZHqTCeDnm6U/hGb
 mOG2KfCGPtdxNDw31PnYw+jfbtuwc1ubV1UCrIKe67y/4rC/8cKimLnlYioBtysZswQ8bfwFysz
 h5LrWpczwb67HQ21bLQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDA2OCBTYWx0ZWRfX2vdOXIziwJAu
 usvWPI36JHnD4NB/oTJEe7QA1NCUQwRu/PkPXVH/FKwz6JsS6+garjXSLm2elTO6P3VG0oPuiv8
 H9/t8Sc+4DgDSxSUseTRJsJzH8ZrEDL5NvQwc+mbupXYJzeWIsq7
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11958
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 bulkscore=10 suspectscore=0 phishscore=0
 priorityscore=1501 impostorscore=10 spamscore=0 lowpriorityscore=10
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611060068

Hi Fuad, Vincent,

On Fri, Nov 06, 2026 at 02:34:55PM +0000, Fuad Tabba wrote:
> Actually, like Vincent pointed out, why the WARN_ON(). The caller can
> just handle the error.

Makes sense, I'll drop the WARN_ON() and just return -EEXIST.

One thing I noticed: the kernel-doc of kvm_pgtable_hyp_map() says that
a mapping over an existing one is "rejected with an error and a
WARN()", and the leaf case in hyp_map_walker_try_leaf() still warns.
Without the WARN_ON(), the comment would no longer match this case.
By the same reasoning, should the leaf case's WARN_ON() go too, in a
separate patch, with the comment reduced to "rejected with an error"?

Thanks,
Xuheng
