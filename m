Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB9E322C6D
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 12:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786538548; cv=none; b=glTZ93VBkfl7OKuwUSk4D7G3G5sYHLAvOCx/hccc8Ilfkm7m5/BEU9C0WhjaIwScfvysnPLLOTDspDvFufUJsSjGhUVHhMnwxtn0DOng9Z+SjOYk8qNVQp5AjKiERgqERz4Am1WtrRlHUgK+S9n6ygRw+NKDaGpEObLnBDDqwvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786538548; c=relaxed/simple;
	bh=LHkQmmIVO12tqfXq5MuBnKiU3Zac/gB4CKobR6v3pWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fe2KkXdt/iFEhjkEuiGEtPADxPK43FMGYLaXpiOjvqFESuAj7pytH4FxI251L01QJEY4SFp9N+Rj+ob1kF+zV5/JvVBmqVgLXQAEJVm9hhfPO6+2H4OIP9RlUWuSqiygDYi9mBLW9hx3Le9USeZyWN7p5g06x1EvXYivXq1SgEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hc07wEyf; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NQ14udX+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hc07wEyf";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NQ14udX+"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67CB48T43319909
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 12:42:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=RpsE0CluZfRv1K7AmPiInqF3
	1WCTjf8G43ue2nF02Wo=; b=hc07wEyf9hg1I2f1Af4LWb4Jsokg20l/rGEwe5rl
	ocDQF+TuF3htAoKsm/rsEG5gAePzRqwEIesef6OglYL+cgmZ0oO0cHLEmkVy/NC/
	od/eWLXtRbBrFzncpV02t4rKejnDJWGEyoVVVKUk19lNLeaw0DOU0x9WzbZi3Rzq
	PE8ITNEdEC9/O6NBHLb9dYr94tuoY7LL7lEodPo0HX80XPltXc5Er7cRzXl6oTFA
	s7ZNlZ+M2j9erAShKWgECpMmULNV6/RNo75pXhKS6StbHpI9lDodoQC8F+eUWhdm
	Q/FJTupgpj2BCmus5KSB50yen1bgVEbRClGc4d91mRB61Q==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g0pmyrjsr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 12:42:20 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbef1d25500so45476a12.1
        for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 05:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786538540; x=1787143340; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RpsE0CluZfRv1K7AmPiInqF31WCTjf8G43ue2nF02Wo=;
        b=NQ14udX+PUUby0bpMaqb/otpOfwdQfCz3z6oCO/7NJKwf1B4ao/cgP0G6wmu/LEzZe
         YOMBxX3iO2c22G/+sLHmkMLd2t9Rc+xaJ6aBRodp2brOlOS4CYiZ0Z2GOCDYXysQGVfD
         qVkLZidLPqIKvJ841D2Vj3Z43n4CsJywzr/CPOKgC24+EJvthzUEj7e5t7hiM69bA36V
         v1VrGCgLqD1IaDwO0EikSVjiTzOpYpjq3VcjC0t0QJnd0yRn+LJdgdrfte7sfz1seFqj
         YBaWPuA346bK2FwaCbZZazOwi443WQWffwMWZwUJT0dE5v3hVdIo4ios1n+3wmyliKOP
         aX2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786538540; x=1787143340;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RpsE0CluZfRv1K7AmPiInqF31WCTjf8G43ue2nF02Wo=;
        b=Bcwx1Rmp75vrgBZkjXPM+dnmANuPdoTPRfgOiIb67UgBaWnoT7QRYu8LRXT+J+VLJx
         q910Xed2/6Og1nqVeVS3iNWHf14KfLkCJvlxf5cpMZYWThTlK+nVWeyFJbn+39rzaR5c
         Ge3c1zZF7ygQbhINmiohLU1cVu9EmrnWnQwnfUccMkhZ2niP8fn1M0tU62TxYiXF+i29
         YSTSsZMYWFgGyFcCQkCMtYpmWjM0OINjoG5KVPIP80fYumcHRdfwIRyzus7jL36FijoN
         e6/7N/JrWor3a8qLT81xfP6tKwMyeMPPn6Mr1/htILotpou7wTtZZBdJXTxoj57v2xfs
         JzVg==
X-Forwarded-Encrypted: i=1; AHgh+RploUn9M3OCJzEAWDqQ1ryNIF319qIv9w1MP/sBCcV+2wZLyQtuymhD5gKnbt7t7GKVEz3C3c0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVJoOiQHTzbiRGeLuowTLpeWwljA3xo3VM/gB3vrrJH1vz2OpP
	d2+4Y3Qt3SbxS4IFwxZDTL3Q/Bhaafse+p7WjUMCIqtTQ36HSA1D2y9ukX4VYz2VijstF1wQtch
	o371zlIJGjwzGq/MES1zDXCnFYBqTkunensmp9COMdcsTf1NGYQsO1gEQGsg=
X-Gm-Gg: AR+sD10kQ3ONnLyFRSHqQt246PljTEIUNGrMs8jD8ZnmsaI6CZmOVBUfwg3B1PkAyJA
	LvYIInEoA6tLhc5CMJQFKFAfkLd8mvp8lQVly+/jVluKSIFNMv7np/P/oG6ETn5USVuPENrt1w/
	dGKbam3QpZ0LxzdF5z8pQmWiCoq4fN82vQQrzBNoIUtF1itRswH0rCz7AgvgXX4kSUOR9z7uv2b
	c6kddsZUIfu8MYa4MXMvIkusa7JSZluAOjfqzAqLd9YZri9jmc7GW1tyFI4HrMh2rA00/sbFdWo
	R7LB3bJ5lgHSA9MVnsj35oj6Td24WjlTRBPHcLJVlF/R5QOoE5dLmnJupbOgRfMIIKCsBTKcEfe
	FS6+/Nqh1pQCWtFkgHyIX7D2ig5VZH4f7nw==
X-Received: by 2002:a05:6a21:700d:b0:3cb:b3ea:858a with SMTP id adf61e73a8af0-3cc3f739945mr5799535637.20.1786538539878;
        Wed, 12 Aug 2026 05:42:19 -0700 (PDT)
X-Received: by 2002:a05:6a21:700d:b0:3cb:b3ea:858a with SMTP id adf61e73a8af0-3cc3f739945mr5799443637.20.1786538539337;
        Wed, 12 Aug 2026 05:42:19 -0700 (PDT)
Received: from hu-pkondeti-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31cf628e42asm13617523eec.15.2026.08.12.05.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 05:42:18 -0700 (PDT)
Date: Wed, 12 Aug 2026 18:12:09 +0530
From: Pavan Kondeti <pavan.kondeti@oss.qualcomm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
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
Message-ID: <7d4e5920-aa20-40cd-954e-037631bd0d6c@quicinc.com>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-8-steven.price@arm.com>
 <ans1ZSwMEKeT9Gfz@arm.com>
 <d4bdecca-517a-4b4b-bf67-cef6b09bc8c1@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4bdecca-517a-4b4b-bf67-cef6b09bc8c1@arm.com>
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEyMDEwMyBTYWx0ZWRfX7JPLdFFZ/7rS
 L6sIp3i4y3ub4bgXaHREI0T0uj81dFyplYZXN3NqUMK/Pwvv/Folc3NQjankORMVwXoWcsjMmDY
 NzOozv4tva3ekKw/NtQ/vIS91me7zKo=
X-Proofpoint-ORIG-GUID: V8o5_0xomiGFEu2jXVCM4uCRYzglCbn_
X-Authority-Analysis: v=2.4 cv=C/fZDwP+ c=1 sm=1 tr=0 ts=6a7c6a2c cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=Oh2cFVv5AAAA:8 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=20KFwNOVAAAA:8
 a=okfElxvwRwk4E0nMkqUA:9 a=CjuIK1q_8ugA:10 a=bFCP_H2QrGi7Okbo017w:22
 a=7KeoIwV6GZqOttXkcoxL:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: V8o5_0xomiGFEu2jXVCM4uCRYzglCbn_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDEwMyBTYWx0ZWRfX6tU4474QIXyr
 30o4/cbjzK9MTCRWvrzMnWwsKrG8kWM4zwYjQ6E0KNvCQPnOpzb+c9mCgyGejJSAMKJPauC88OO
 4PNkV4u1ngcNUGBIXFtPAtyvpUwCoJL/NhKWOmNCiDYByhsudMh007poYkNeVhKnWEg6iTF9bP2
 TwucT2SgnYns53s47736pwkhudKh8ek2XPShmD5aJBH9tKsf9ldyvdN4HFEJ9HkOY0/rfQa9K56
 5TgIVxKb5vKabfHA8UhP8c3mcyVW7HthlNaEz7AqSpxmkd7kz4SXlIJ17LpoCLTh4Dx6ftGCyTp
 Qtd0sKBcEcSmN/MmNFJcvOEa3Vnw1MkZjIiQt0vqJ0ogoMMX75JFoBpwQpUsMREfVfZSWH9YseM
 1sn0YQr3D18XzFYO+AmnDU12tKH1nRFBELsyCQ0PnfLE+zkzcnRcAr3HrpHzC0TxEIVtqaHsjAa
 41U85uyPrRdEpT5PMuw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-12_03,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608120103

On Tue, Aug 11, 2026 at 04:11:13PM +0100, Suzuki K Poulose wrote:
> On 11/08/2026 15:44, Catalin Marinas wrote:
> > On Mon, Aug 03, 2026 at 02:43:23PM +0100, Steven Price wrote:
> > > If the host attempts to access granules that have been delegated for use
> > > in a realm these accesses will be caught and will trigger a Granule
> > > Protection Fault (GPF).
> > > 
> > > A fault during a page walk signals a bug in the kernel and is handled by
> > > oopsing the kernel. A non-page walk fault could be caused by user space
> > > having access to a page which has been delegated to the kernel and will
> > > trigger a SIGBUS to allow debugging why user space is trying to access a
> > > delegated page.
> > > 
> > > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > Signed-off-by: Steven Price <steven.price@arm.com>
> > > ---
> > > Changes since v10:
> > >   * Don't call arm64_notify_die() in do_gpf() but simply return 1.
> > > Changes since v2:
> > >   * Include missing "Granule Protection Fault at level -1"
> > > ---
> > >   arch/arm64/mm/fault.c | 28 ++++++++++++++++++++++------
> > >   1 file changed, 22 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> > > index 85e23388f9bb..ea3ae0ca7dba 100644
> > > --- a/arch/arm64/mm/fault.c
> > > +++ b/arch/arm64/mm/fault.c
> > > @@ -909,6 +909,22 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
> > >   	return 0;
> > >   }
> > > +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_regs *regs)
> > > +{
> > > +	const struct fault_info *inf = esr_to_fault_info(esr);
> > > +
> > > +	die_kernel_fault(inf->name, far, esr, regs);
> > > +	return 0;
> > > +}
> > > +
> > > +static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
> > > +{
> > > +	if (!is_el1_instruction_abort(esr) && fixup_exception(regs, esr))
> > > +		return 0;
> > > +
> > > +	return 1;
> > > +}
> > 
> > Is there a valid case for fixup_exception() here? IOW, do we ever have a
> > valid user mapping of the pages delegated to a guest? If the above is
> > considered a kernel bug, I'd not silently ignore this (like return less
> > bytes copied or -EFAULT to user) but rather warn, potentially
> > rate-limited.
> 
> Good question. This shouldn't be a valid case. We expect the VMM to use
> guest_memfd and that should prevent any mmaps and thus fixups shouldn't
> be required. That said, this series doesn't enforce that the VMM uses
> GMEM backed memslots for Guest RAM. We should probably do that while
> mapping things in.
> 
> With that, we could drop that fixup and scream a bit.
> 

There is a valid case for fixup_exception() to be needed here in GPF
handling.

-000 |load_unaligned_zeropad(inline)
-000 |hash_name(inline)
-000 |link_path_walk()
-001 |path_lookupat()
-002 |filename_lookup()
-003 |vfs_statx()
-004 |vfs_fstatat()

We observed this in Android running Gunyah when the page is mapped in
EL1 but unmapped at EL2. path_lookupat() can actually handle this
via fixup_exeption() when a word load crosses the page boundary.
However, Gunyah injects a Synchronous External Abort and we have
a downstream patch [1] that adds fixup_exception() in do_sea(). pKVM
injects [2] such faults back to EL1 and fixup_exception() is taken care.

This patch allows Hypervisors like Gunyah to simulate GPF instead of
Synchronous External Abort for kernel to gracefully handle the 
load_unaligned_zeropad() access.

Thanks,
Pavan


[1] https://android-review.googlesource.com/c/kernel/common/+/2996781
[2] https://lore.kernel.org/all/20260330144841.26181-20-will@kernel.org/
