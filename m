From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 6/6] run_tests: allow passing of options to
 QEMU
Date: Thu, 12 Jan 2017 18:50:00 +0100
Message-ID: <648638bd-a90e-ee98-337a-223ed533f53a@redhat.com>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
 <20170111162841.15569-7-alex.bennee@linaro.org>
 <20170112173204.ufd2ggw7iz7xv772@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C26D4019A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 12:48:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yjVb03ulxE35 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 12:48:15 -0500 (EST)
Received: from mail-lf0-f65.google.com (mail-lf0-f65.google.com
 [209.85.215.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B37C40194
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 12:48:15 -0500 (EST)
Received: by mail-lf0-f65.google.com with SMTP id q89so2929574lfi.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 09:50:01 -0800 (PST)
In-Reply-To: <20170112173204.ufd2ggw7iz7xv772@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 12/01/2017 18:32, Andrew Jones wrote:
>>  
>> +# Any options left for QEMU?
>> +shift $((OPTIND-1))
>> +if [ "$#" -gt  0 ]; then
>> +    extra_opts="$@"
>> +fi
> We can unconditionally do the extra_opts="$@", extra_opts will just
> be null in the case there aren't more args, like it was before.

extra_opts is not an array, so this would mess up options that contain
spaces.  (Alex's patch in general, not your tweak).

Paolo

>> +
>>  RUNTIME_log_stderr () { cat >> test.log; }
>>  RUNTIME_log_stdout () {
>>      if [ "$PRETTY_PRINT_STACKS" = "yes" ]; then
>> @@ -59,4 +68,4 @@ RUNTIME_log_stdout () {
>>  config=$TEST_DIR/unittests.cfg
>>  rm -f test.log
>>  printf "BUILD_HEAD=$(cat build-head)\n\n" > test.log
>> -for_each_unittest $config run
>> +for_each_unittest $config run "$extra_opts"
