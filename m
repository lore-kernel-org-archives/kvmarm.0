Return-Path: <SRS0=Ladk=4V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12D3C3F2D1
	for <kvmarm@archiver.kernel.org>; Wed,  4 Mar 2020 18:21:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E8A22146E
	for <kvmarm@archiver.kernel.org>; Wed,  4 Mar 2020 18:21:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eLqyWLKS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E8A22146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D92994AF67;
	Wed,  4 Mar 2020 13:21:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kQusvUXiu1vx; Wed,  4 Mar 2020 13:21:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADDF74AEFA;
	Wed,  4 Mar 2020 13:21:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32A654AEFA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2020 13:21:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DQVw2Xhkg4so for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2020 13:21:36 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 462A94AED2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2020 13:21:36 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1583346096;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=nNKk6V4UafjEY7RM/4q9Bsej2pxdLWtMJlUp2kDxLcg=;
 b=eLqyWLKSwxos5SF+ZbxgfkULB2QoMptn0yZuerlY9DixZZDPAP4nsOl9wVq0SyyXUygAXF
 zG0oQTT2wOUNoluAN+D+84ramYhVrKoUS74Pzza5JLgPRAIQfsROElDRqbRSZLVlk6Uojq
 H17v+8DBjgn1rLvgmU8CPx2CO6dOaSs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-jSpBxr19NSqeuK5EvpGR7Q-1; Wed, 04 Mar 2020 13:21:32 -0500
X-MC-Unique: jSpBxr19NSqeuK5EvpGR7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EF38100550E;
 Wed,  4 Mar 2020 18:21:30 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B3D158B777;
 Wed,  4 Mar 2020 18:21:25 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/9] arm: pmu: Add a pmu struct
To: Andre Przywara <andre.przywara@arm.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
 <20200130112510.15154-4-eric.auger@redhat.com>
 <20200304180158.4d9e3b8c@donnerap.cambridge.arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <c11424a4-22cc-3ca2-0949-f39c0c4c8b6b@redhat.com>
Date: Wed, 4 Mar 2020 19:21:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304180158.4d9e3b8c@donnerap.cambridge.arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, andrew.murray@arm.com, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
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

Hi Andre,

On 3/4/20 7:02 PM, Andre Przywara wrote:
> On Thu, 30 Jan 2020 12:25:04 +0100
> Eric Auger <eric.auger@redhat.com> wrote:
> 
>> This struct aims at storing information potentially used by
>> all tests such as the pmu version, the read-only part of the
>> PMCR, the number of implemented event counters, ...
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> As I stated already in v1:
Hum that's an oversight. Please forgive for the 2 R-b's I have forgotten.

Thanks

Eric
> 
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>


> 
> Cheers,
> Andre
> 
>> ---
>>  arm/pmu.c | 30 +++++++++++++++++++++++++-----
>>  1 file changed, 25 insertions(+), 5 deletions(-)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index e5e012d..d24857e 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -33,7 +33,14 @@
>>  
>>  #define NR_SAMPLES 10
>>  
>> -static unsigned int pmu_version;
>> +struct pmu {
>> +	unsigned int version;
>> +	unsigned int nb_implemented_counters;
>> +	uint32_t pmcr_ro;
>> +};
>> +
>> +static struct pmu pmu;
>> +
>>  #if defined(__arm__)
>>  #define ID_DFR0_PERFMON_SHIFT 24
>>  #define ID_DFR0_PERFMON_MASK  0xf
>> @@ -265,7 +272,7 @@ static bool check_cpi(int cpi)
>>  static void pmccntr64_test(void)
>>  {
>>  #ifdef __arm__
>> -	if (pmu_version == 0x3) {
>> +	if (pmu.version == 0x3) {
>>  		if (ERRATA(9e3f7a296940)) {
>>  			write_sysreg(0xdead, PMCCNTR64);
>>  			report(read_sysreg(PMCCNTR64) == 0xdead, "pmccntr64");
>> @@ -278,9 +285,22 @@ static void pmccntr64_test(void)
>>  /* Return FALSE if no PMU found, otherwise return TRUE */
>>  static bool pmu_probe(void)
>>  {
>> -	pmu_version = get_pmu_version();
>> -	report_info("PMU version: %d", pmu_version);
>> -	return pmu_version != 0 && pmu_version != 0xf;
>> +	uint32_t pmcr;
>> +
>> +	pmu.version = get_pmu_version();
>> +	report_info("PMU version: %d", pmu.version);
>> +
>> +	if (pmu.version == 0 || pmu.version == 0xF)
>> +		return false;
>> +
>> +	pmcr = get_pmcr();
>> +	pmu.pmcr_ro = pmcr & 0xFFFFFF80;
>> +	pmu.nb_implemented_counters =
>> +		(pmcr >> PMU_PMCR_N_SHIFT) & PMU_PMCR_N_MASK;
>> +	report_info("Implements %d event counters",
>> +		    pmu.nb_implemented_counters);
>> +
>> +	return true;
>>  }
>>  
>>  int main(int argc, char *argv[])
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
