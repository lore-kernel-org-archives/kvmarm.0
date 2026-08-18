Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBD64756B0
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 12:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787057459; cv=none; b=BAcyk+YFUEOOOVE1jL1HpMV9P/NbYf8JoJf9gZCIbMPSc9LG/7EgZZcRu/l3aLEPd6K7RyCTvuCWWQ8nDElUPH+rgLXOLdCEq7IkcxOoCo1Vu8bsIKZv38ZO/GyrY6SckQViQHsn0mpUS/70zcqCnZe7/Mtx9RK6BWeGYNUTrDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787057459; c=relaxed/simple;
	bh=yDxDlyqLp5oTixkhjTCkGBUE3dyTpe4DBIToh/U/hNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XmYpKgdzYQmLd8EtsnbPCIpF8wEPMSBUBbNnxPpF7rPyWc9PjF0f9W7/dF92Ik9vABXkM8SMgMKgK9h+lFZ3tx8LLIeQR5YpK4YD8yThJGYXprOY/DQNt17DtySSWws5B6oJ/3AGk5l3KcNafU3jK0pPlsgI1ngUs95d6p7F9o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SvieMOuB; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SvieMOuB"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ce7d2adef4so13257425ad.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 05:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787057455; x=1787662255; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QydW9EfPsAktXSdxMNlPMiQEqHQr57p4gRR6UU4ns3M=;
        b=SvieMOuBajX5GV5VIO+guLIoLTEHf0tY0PqsJL/9z6nHcBub5wCiTLy63+a7CS91Np
         UmscKPm+0FVUdITUTw3BjrXujc32rUWeBQ4PMbFOGG9CfRuBNaepw6h1zwxzfCwA4jST
         wG4C/AnPojHnSrcqYRoblMtOKND2k1jOS8ywGNvk14W5IxXonjJwjPzzIYOShajakQg6
         34nATFsk67XRHL5MH9kRksYyqZEBMEEyXGofu+AxanJaMnmq4Gppnn+Kz3nAJLoWjTBE
         PjpyOIuMZiJCP+8X8kzIRmkCc1K+uYTfzX0jeD7T5XwtCw9itCDDS0d9FGZxh1fRHhKR
         nbKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787057455; x=1787662255;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QydW9EfPsAktXSdxMNlPMiQEqHQr57p4gRR6UU4ns3M=;
        b=PnHixa60r/x7Zu6EqQAOE2AD/4F7uKiqgj/4kP/WtGHr2cZCcyIWa0HuEQnreih84g
         pXJA8qV1l13W6pK2lAgixwy9j9Gu8pT6KyX+75ReUVIAN6powjppnfoEdqrvEtUkeEiW
         jccO+yEA/HtznCxKqGHYhvOEKY36kSP3vgipczkEp/tj9e3KHhyDsZfHqMtRRNVg4xk/
         FoRSayy4CTJLPxUHhTAr9ml5LYbEjJmbuncBusXE08gswxxh550IwxHJrC5ebjfuJrx1
         SQlf4OwELEBg6ZI9YEWQDTfKVuvifY4DciSfXi9XA8Jxt3wBeooLBuafkeee63MBy+dk
         HURg==
X-Forwarded-Encrypted: i=1; AHgh+RqauJQ1JXSMRDV9+bLeqTVSea5Vl5p0nJZ1tu4Dao/sLQsdV7iPVYjn8xhOnLjcrQ7gjw3cXXQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywme5mK2uhO6zL3ehtVfbjr6wSGviEAqcG9OERRzLI3muzo3psz
	lJxjcVWS/0orAcpdOnYwSwQ0vnWeUEg45VbNrEAFW8Op5EN5VjKF9LI1
X-Gm-Gg: AR+sD127gP38CnuSNWJdDvouxC4rAp3rurKqnTm0F+PpTpizMjaOZEz5frkm+WdsTnr
	Nd0hIs6pOeU+2Cm+tmBXLPR2JO2pUZmJUKSDzZoZA18LNolf9NCbj+vwfY4J03hCNXuBsBoTlPK
	ZS/C7iRjlOCcAqGsVJ2YC5R4g0xy0Ya6d1AoQt085M0MwTkqvE9IQdmnzSrLySQFz4bWl8tvcdp
	0Tfgz9y0Yah8fE/s/BWuBT1G1GVbUL7B8aK7BsegBuxSSVP+uAtxlgfh16KdAzDsRotgoMvotOF
	RiV+WSMRCE33jdZhOrFdD+Hhph9l9pXYHQRxgdDx+aIv1rzBHU+chptFSidHTSHcZlaUE6GtFod
	0G3qwdyqwSV67jRziq796YGfHpBya6KM5uOf1ePryJciXeoL9M9uSmtQgRs6Hf4bsOHSwOJdAh5
	uhjDO4Vt4cq6tV5rSQAczuOcs6mA30guDyTm1XwkrEmn0eFEbAKXTF2GJpl7uCbINoyKqqjPo3W
	rk0LeyJXdZ9dFTmUg9WYfhP1To=
X-Received: by 2002:a17:903:1a08:b0:2d3:7887:7e7f with SMTP id d9443c01a7336-2d3b0c5de30mr412838845ad.11.1787057454413;
        Tue, 18 Aug 2026 05:50:54 -0700 (PDT)
Received: from [10.26.143.42] ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1ef83d6sm14172995ad.78.2026.08.18.05.50.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 05:50:54 -0700 (PDT)
Message-ID: <6799252e-d310-442a-87c3-279d0d71ecef@gmail.com>
Date: Tue, 18 Aug 2026 20:50:51 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] KVM: selftests: arm64: Skip sea_to_user when EINJ
 places no poison
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, sashiko-reviews@lists.linux.dev
References: <20260818112920.26252-1-likexu@tencent.com>
 <20260818112920.26252-4-likexu@tencent.com>
 <20260818114103.433F01F000E9@smtp.kernel.org>
Content-Language: en-US
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20260818114103.433F01F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/26 7:41 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] The check skips the test unconditionally on any guest assertion failure, masking unrelated or future bugs.
> --
> 
> --- Patch [3]: [PATCH v2 3/3] KVM: selftests: arm64: Skip sea_to_user when EINJ places no poison ---
> commit 3bedaa634d562c6cc85fb3726d30fa40f0ed350d
> Author: Like Xu <like.xu.linux@gmail.com>
> 
> KVM: selftests: arm64: Skip sea_to_user when EINJ places no poison
> 
> This commit modifies the sea_to_user selftest to skip rather than fail
> when the firmware does not leave consumable poison in memory. It detects
> this condition by checking if the exit reason is not KVM_EXIT_ARM_SEA
> and a UCALL_ABORT is received from the guest.
> 
>> diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c b/tools/testing/selftests/kvm/arm64/sea_to_user.c
>> index 7cf95da8e594d..d4af6e0eed288 100644
>> --- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
>> +++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
>> @@ -215,13 +215,33 @@ static void run_vm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>>   
>>   	ksft_print_msg("Dump kvm_run info about KVM_EXIT_%s\n",
>>   		       exit_reason_str(run->exit_reason));
>> +
>> +	/*
>> +	 * The guest's read of the injected location is expected to trap to KVM
>> +	 * as an SEA. If it does not, the injected error was never placed as
>> +	 * consumable poison: some firmware honours EINJ's notrigger request by
>> +	 * arming the poison only as part of the (now skipped) trigger step, so
>> +	 * nothing is left in memory for the guest to consume. The guest then
>> +	 * reads back the sentinel value and reports it via GUEST_FAIL, which
>> +	 * arm64 delivers as a ucall over MMIO (hence a KVM_EXIT_MMIO here).
>> +	 * Treat that as "this platform cannot host the test" and skip, matching
>> +	 * the requirement documented at the top of this file, rather than
>> +	 * failing on a hardware/firmware limitation the test cannot control.
>> +	 */
>> +	if (run->exit_reason != KVM_EXIT_ARM_SEA &&
>> +	    get_ucall(vcpu, &uc) == UCALL_ABORT) {
> 
> [Severity: Medium]
> Does this unconditionally skip the test on any guest assertion failure,
> masking unrelated or future bugs?
> 
> If KVM fails to exit to userspace and instead incorrectly injects a
> Data Abort to the guest with an unexpected syndrome, the guest's SEA
> handler might fail a GUEST_ASSERT_EQ check. This would emit a
> UCALL_ABORT over MMIO.
> 
> The host loop here interprets any UCALL_ABORT during this phase as a
> missing EINJ poison limitation, skipping the test instead of reporting
> the failure.
> 
> Can we check the specific assertion failure reason or uc.buffer string
> instead of catching all UCALL_ABORTs?

For any human to double check:

diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c 
b/tools/testing/selftests/kvm/arm64/sea_to_user.c
index 7cf95da8e594d..f1d156d7645cc 100644
--- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
+++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
@@ -165,11 +165,16 @@ static void guest_code(void)
  {
  	u64 guest_data;

-	/* Consumes error will cause a SEA. */
+	/* Consuming a real poison faults as an SEA and never returns here. */
  	guest_data = *(u64 *)EINJ_GVA;

-	GUEST_FAIL("Poison not protected by SEA: gva=%#lx, guest_data=%#lx\n",
-		   EINJ_GVA, guest_data);
+	/*
+	 * The read returned, so this platform placed no consumable poison.
+	 * Report the value read as a positive signal that is distinct from a
+	 * GUEST_ASSERT failure, so the host can skip on this limitation without
+	 * masking a genuine SEA-handling failure.
+	 */
+	GUEST_SYNC1(guest_data);
  }

  static void expect_sea_handler(struct ex_regs *regs)
@@ -215,13 +220,46 @@ static void run_vm(struct kvm_vm *vm, struct 
kvm_vcpu *vcpu)

  	ksft_print_msg("Dump kvm_run info about KVM_EXIT_%s\n",
  		       exit_reason_str(run->exit_reason));
+
+	/*
+	 * The guest's read of the injected location must trap to KVM as an
+	 * SEA. If the exit is something else, decode what the guest did before
+	 * deciding whether to skip or fail:
+	 *
+	 *  - UCALL_SYNC: the read returned instead of faulting, so no
+	 *    consumable poison was placed. Some firmware only arms EINJ poison
+	 *    as part of the trigger step that notrigger=1 skips, leaving
+	 *    nothing for the guest to consume; arm64 delivers the ucall as an
+	 *    MMIO write (hence KVM_EXIT_MMIO). This platform cannot host the
+	 *    test, so skip, matching the requirement documented at the top.
+	 *  - UCALL_ABORT: the guest took an abort but its SEA handler failed an
+	 *    assertion. That is a genuine problem, so report it rather than
+	 *    masking it as the limitation above.
+	 *  - anything else: fall through to the exit-reason assertion.
+	 */
+	if (run->exit_reason != KVM_EXIT_ARM_SEA) {
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			ksft_print_msg("Guest read back %#lx without an SEA\n",
+				       uc.args[0]);
+			ksft_exit_skip("EINJ notrigger placed no consumable poison on this 
platform\n");
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		default:
+			break;
+		}
+	}
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);
+
+	/* arm_sea holds valid data only for a KVM_EXIT_ARM_SEA exit. */
  	ksft_print_msg("kvm_run.arm_sea: esr=%#llx, flags=%#llx\n",
  		       run->arm_sea.esr, run->arm_sea.flags);
  	ksft_print_msg("kvm_run.arm_sea: gva=%#llx, gpa=%#llx\n",
  		       run->arm_sea.gva, run->arm_sea.gpa);

-	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);
-
  	esr = run->arm_sea.esr;
  	TEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_LOW);
  	TEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);

> 
>> +		ksft_print_msg("Guest consumed no SEA: %s", uc.buffer);
>> +		ksft_exit_skip("EINJ notrigger placed no consumable poison on this platform\n");
>> +	}
>> +
>> +	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);
>> +
>> +	/* arm_sea holds valid data only for a KVM_EXIT_ARM_SEA exit. */
>>   	ksft_print_msg("kvm_run.arm_sea: esr=%#llx, flags=%#llx\n",
>>   		       run->arm_sea.esr, run->arm_sea.flags);
>>   	ksft_print_msg("kvm_run.arm_sea: gva=%#llx, gpa=%#llx\n",
> 

