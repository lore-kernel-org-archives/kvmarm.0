Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E163AD3C
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 11:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686568729;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=36d2tYssi0iWXab/pB5scxxolTXYqFelDGqk9IVpbfg=;
	b=GNM7uhE8ypaO3ftctMcn1jS46LrjLanwVcXE6OkT4nG8POCcLhJ1bTDfVz8V/h+lRAbPpM
	Zm+5uEofkvKTdlpRuWK/Imoo7g8ZUlT7HfMnxEzvYDPGpH62nnqQuC+nBUlCFjSk/Tect7
	9xGohG2z4U5NudlZUe36PS2juJBWyFk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-WFFF9uCqO_iBEVhnCIfLcQ-1; Mon, 12 Jun 2023 07:18:44 -0400
X-MC-Unique: WFFF9uCqO_iBEVhnCIfLcQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05E838032FE;
	Mon, 12 Jun 2023 11:18:44 +0000 (UTC)
Received: from [10.64.54.97] (vpn2-54-97.bne.redhat.com [10.64.54.97])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 83EFB492CAC;
	Mon, 12 Jun 2023 11:18:41 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] runtime: Allow to specify properties for
 accelerator
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
 nrb@linux.ibm.com, thuth@redhat.com, shan.gavin@gmail.com
References: <20230612050708.584111-1-gshan@redhat.com>
 <20230612-4c2e1b03885ddc0f55eb1988@orel>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <46ee043a-1ef4-4786-459c-f1b9e6fe7e96@redhat.com>
Date: Mon, 12 Jun 2023 21:18:39 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230612-4c2e1b03885ddc0f55eb1988@orel>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9

Hi Drew,

On 6/12/23 6:27 PM, Andrew Jones wrote:
> On Mon, Jun 12, 2023 at 03:07:08PM +1000, Gavin Shan wrote:
>> There are extra properties for accelerators to enable the specific
>> features. For example, the dirty ring for KVM accelerator can be
>> enabled by "-accel kvm,dirty-ring-size=65536". Unfortuntely, the
>> extra properties for the accelerators aren't supported. It makes
>> it's impossible to test the combination of KVM and dirty ring
>> as the following error message indicates.
>>
>>    # cd /home/gavin/sandbox/kvm-unit-tests/tests
>>    # QEMU=/home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
>>      ACCEL=kvm,dirty-ring-size=65536 ./its-migration
>>       :
>>    BUILD_HEAD=2fffb37e
>>    timeout -k 1s --foreground 90s /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
>>    -nodefaults -machine virt -accel kvm,dirty-ring-size=65536 -cpu cortex-a57             \
>>    -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd   \
>>    -device pci-testdev -display none -serial stdio -kernel _NO_FILE_4Uhere_ -smp 160      \
>>    -machine gic-version=3 -append its-pending-migration # -initrd /tmp/tmp.gfDLa1EtWk
>>    qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument
>>
>> Allow to specify extra properties for accelerators. With this, the
>> "its-migration" can be tested for the combination of KVM and dirty
>> ring.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arm/run               | 4 ++--
>>   scripts/arch-run.bash | 4 ++--
>>   2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arm/run b/arm/run
>> index c6f25b8..bbf80e0 100755
>> --- a/arm/run
>> +++ b/arm/run
>> @@ -35,13 +35,13 @@ fi
>>   
>>   M='-machine virt'
>>   
>> -if [ "$ACCEL" = "kvm" ]; then
>> +if [[ "$ACCEL" =~ ^kvm.* ]]; then
>>   	if $qemu $M,\? | grep -q gic-version; then
>>   		M+=',gic-version=host'
>>   	fi
>>   fi
>>   
>> -if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
>> +if [[ "$ACCEL" =~ ^kvm.* ]] || [[ "$ACCEL" =~ ^hvf.* ]]; then
>>   	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
>>   		processor="host"
>>   		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
>> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
>> index 51e4b97..e20b965 100644
>> --- a/scripts/arch-run.bash
>> +++ b/scripts/arch-run.bash
>> @@ -412,11 +412,11 @@ hvf_available ()
>>   
>>   get_qemu_accelerator ()
>>   {
>> -	if [ "$ACCEL" = "kvm" ] && ! kvm_available; then
>> +	if [[ "$ACCEL" =~ ^kvm.* ]] && [[ ! kvm_available ]]; then
>>   		echo "KVM is needed, but not available on this host" >&2
>>   		return 2
>>   	fi
>> -	if [ "$ACCEL" = "hvf" ] && ! hvf_available; then
>> +	if [[ "$ACCEL" =~ ^hvf.* ]] && [[ ! hvf_available ]]; then
>>   		echo "HVF is needed, but not available on this host" >&2
>>   		return 2
>>   	fi
>> -- 
> 
> I'd prefer that when we want to match 'kvm', 'tcg', etc. that we split
> on the first comma, rather than use a regular expression that allows
> arbitrary characters to follow the pattern. Actually
> get_qemu_accelerator() could do the splitting itself, providing two
> variables, ACCEL (only kvm, tcg, etc.) and ACCEL_PROPS (which is
> either null or has a leading comma). Then command lines just need
> to use $ACCEL$ACCEL_PROPS. If we do that, then get_qemu_accelerator()
> should also allow the user to pre-split, i.e.
> 
>    ACCEL=kvm ACCEL_PROPS=dirty-ring-size=65536 arm/run ...
> 
> Finally, did you also test this with the accel property in the
> unittests.cfg file run with run_tests.sh?
> 

Thanks for your quick comments. I think we can be smart to split
$ACCEL in get_qemu_accelarator() into $ACCEL and $ACCEL_PROPS if you
agree. It's not free to maintain another user visible property for
$ACCEL_PROPS.

I forgot to run "./runtest.sh" to make sure nothing is broken. I will
do this before v2 is posted. Note that v2 will be posted shortly :)

Thanks,
Gavin




