From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH 1/6] libcflat: add PRI(dux)32 format types
Date: Thu, 12 Jan 2017 12:39:50 +0000
Message-ID: <87k2a0310p.fsf@linaro.org>
References: <20170111162841.15569-1-alex.bennee@linaro.org> <20170111162841.15569-2-alex.bennee@linaro.org> <4286b719-ff75-d2cd-68b5-cb9d9bb89553@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <4286b719-ff75-d2cd-68b5-cb9d9bb89553@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: drjones@redhat.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu


Paolo Bonzini <pbonzini@redhat.com> writes:

> On 11/01/2017 17:28, Alex Bennée wrote:
>> So we can have portable formatting of uint32_t types. However there is
>> a catch. Different compilers can use legally subtly different types
>> though so we need to probe the compiler defined intdef.h first.
>
> Interesting, what platform has long uint32_t?  I thought the issue was
> whether 64-bit is long or "long long".

I haven't run into that one. This came up with the arm-none-eabi-gcc on
my overdrive01 box. According to the toolchain guys there is no particular
reason a 32bit compiler can't use long for its natural word length.

The native compiler on Debian armhf doesn't do this but the
arm-none-eabi-gcc compilers on both 64bit and 32bit Debian need this.

>
> Paolo
>
>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>> ---
>>  Makefile       |  1 +
>>  configure      | 13 +++++++++++++
>>  lib/libcflat.h |  9 +++++++++
>>  3 files changed, 23 insertions(+)
>>
>> diff --git a/Makefile b/Makefile
>> index a32333b..9822d9a 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -55,6 +55,7 @@ CFLAGS += $(fomit_frame_pointer)
>>  CFLAGS += $(fno_stack_protector)
>>  CFLAGS += $(fno_stack_protector_all)
>>  CFLAGS += $(wno_frame_address)
>> +CFLAGS += $(if $(U32_LONG_FMT),-D__U32_LONG_FMT__,)
>>
>>  CXXFLAGS += $(CFLAGS)
>>
>> diff --git a/configure b/configure
>> index 995c8fa..127868c 100755
>> --- a/configure
>> +++ b/configure
>> @@ -109,6 +109,18 @@ if [ -f $testdir/run ]; then
>>      ln -fs $testdir/run $testdir-run
>>  fi
>>
>> +# check if uint32_t needs a long format modifier
>> +cat << EOF > lib_test.c
>> +#include <inttypes.h>
>> +EOF
>> +
>> +$cross_prefix$cc lib_test.c -E | grep "typedef" | grep "long" | grep "uint32_t" &> /dev/null
>> +exit=$?
>> +if [ $exit -eq 0 ]; then
>> +    u32_long=true
>> +fi
>> +rm -f lib_test.c
>> +
>>  # check for dependent 32 bit libraries
>>  if [ "$arch" != "arm" ]; then
>>  cat << EOF > lib_test.c
>> @@ -155,4 +167,5 @@ TEST_DIR=$testdir
>>  FIRMWARE=$firmware
>>  ENDIAN=$endian
>>  PRETTY_PRINT_STACKS=$pretty_print_stacks
>> +U32_LONG_FMT=$u32_long
>>  EOF
>> diff --git a/lib/libcflat.h b/lib/libcflat.h
>> index 380395f..e80fc50 100644
>> --- a/lib/libcflat.h
>> +++ b/lib/libcflat.h
>> @@ -58,12 +58,21 @@ typedef _Bool		bool;
>>  #define true  1
>>
>>  #if __SIZEOF_LONG__ == 8
>> +#  define __PRI32_PREFIX
>>  #  define __PRI64_PREFIX	"l"
>>  #  define __PRIPTR_PREFIX	"l"
>>  #else
>> +#if defined(__U32_LONG_FMT__)
>> +#  define __PRI32_PREFIX        "l"
>> +#else
>> +#  define __PRI32_PREFIX
>> +#endif
>>  #  define __PRI64_PREFIX	"ll"
>>  #  define __PRIPTR_PREFIX
>>  #endif
>> +#define PRId32  __PRI32_PREFIX	"d"
>> +#define PRIu32  __PRI32_PREFIX	"u"
>> +#define PRIx32  __PRI32_PREFIX	"x"
>>  #define PRId64  __PRI64_PREFIX	"d"
>>  #define PRIu64  __PRI64_PREFIX	"u"
>>  #define PRIx64  __PRI64_PREFIX	"x"
>>


--
Alex Bennée
