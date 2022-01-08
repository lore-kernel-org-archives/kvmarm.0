Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 197ABC433EF
	for <kvmarm@archiver.kernel.org>; Sat,  8 Jan 2022 13:42:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DB7249F02;
	Sat,  8 Jan 2022 08:42:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r1XAV8Opfo7a; Sat,  8 Jan 2022 08:42:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79D8249F08;
	Sat,  8 Jan 2022 08:42:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4742F49F08
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 Jan 2022 08:42:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8SYGLzHINr9J for <kvmarm@lists.cs.columbia.edu>;
 Sat,  8 Jan 2022 08:42:42 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3FBB49F02
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 Jan 2022 08:42:41 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 7F935CE097D;
 Sat,  8 Jan 2022 13:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3A8C36AE5;
 Sat,  8 Jan 2022 13:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1641649356;
 bh=hQLJg/reC9b+EvXMNlt1up4GO6wGeIenlkDQEvW4m3g=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=oTaJDqri17ndldlKbvClJSSXBCdq5mYI5nozNYP8x+SFn21vj/kI+cqg5Sui3KKPX
 O+PuK+6mdgOqA17X6cVNbaM+5SwbekFYlCv0m4IQLlj2HpOAxZ1j2zqsAYuHg37+oC
 b8EK/eg+PYopiLoQe/3cha1x7sQNuKUhRLRY9OS2g3zu1t2uoBfWRFOAZLZuAP3/s1
 uOHuxbEdXOyX/BDZcRy8yKLicG6CB6GlAtaVtKBjsUqoNwHXg1+cJmn6ATj1LWuL1E
 kcvGvMyeq+9qxBCPxb9Ue6PNqZROwCVOjJoSZkNG7m7JxkoUQtqh30E6PRtGZhkqD0
 MeIM6GEITMgQA==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1n6BzO-00GlKS-MH; Sat, 08 Jan 2022 13:42:34 +0000
MIME-Version: 1.0
Date: Sat, 08 Jan 2022 13:42:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v3] hw/arm/virt: KVM: Enable PAuth when supported by the
 host
In-Reply-To: <a3d32f18-dbbb-e462-82ce-722f424707f9@linaro.org>
References: <20220107150154.2490308-1-maz@kernel.org>
 <a3d32f18-dbbb-e462-82ce-722f424707f9@linaro.org>
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <c9a3552aa067ba691055841b5e3fb7b7@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: richard.henderson@linaro.org, qemu-devel@nongnu.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com,
 eric.auger@redhat.com, peter.maydell@linaro.org, drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2022-01-07 20:23, Richard Henderson wrote:
> On 1/7/22 7:01 AM, Marc Zyngier wrote:
>> @@ -1380,17 +1380,10 @@ void arm_cpu_finalize_features(ARMCPU *cpu, 
>> Error **errp)
>>               return;
>>           }
>>   -        /*
>> -         * KVM does not support modifications to this feature.
>> -         * We have not registered the cpu properties when KVM
>> -         * is in use, so the user will not be able to set them.
>> -         */
>> -        if (!kvm_enabled()) {
>> -            arm_cpu_pauth_finalize(cpu, &local_err);
>> -            if (local_err != NULL) {
>> +        arm_cpu_pauth_finalize(cpu, &local_err);
>> +        if (local_err != NULL) {
>>                   error_propagate(errp, local_err);
>>                   return;
>> -            }
>>           }
> 
> Indentation is still off -- error + return should be out-dented one 
> level.
> 

Duh. Clearly, my brain can't spot these. Apologies for the extra noise.

> Otherwise,
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

Thanks. I'll repost a version shortly, unless someone shouts.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
