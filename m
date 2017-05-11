From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC kvm-unit-tests PATCH 5/8] Makefile: add explicit mkdir for .o targets
Date: Thu, 11 May 2017 16:30:24 +0100
Message-ID: <87mvaj4din.fsf@linaro.org>
References: <20170406190727.5624-1-alex.bennee@linaro.org> <20170406190727.5624-6-alex.bennee@linaro.org> <a8eb190a-3487-1a89-0069-789b62860b3e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <a8eb190a-3487-1a89-0069-789b62860b3e@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: drjones@redhat.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu


Paolo Bonzini <pbonzini@redhat.com> writes:

> On 06/04/2017 21:07, Alex Bennée wrote:
>> This is fairly direct way of ensuring the target build directories are
>> created before we build a binary blob. mkdir -p fails gracefully if
>> the directory is already there.
>>
>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>> ---
>>  Makefile | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/Makefile b/Makefile
>> index 781186e..56598df 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -79,8 +79,13 @@ $(LIBFDT_archive): $(addprefix $(LIBFDT_objdir)/,$(LIBFDT_OBJS))
>>  	$(AR) rcs $@ $^
>>
>>  %.o: %.S
>> +	mkdir -p $(dir $@)
>
> Should this use @ for cleanliness?

I'm not sure I follow. Did you mean use $(@D) directly?

>
> Paolo
>
>>  	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>>
>> +%.o: %.c
>> +	mkdir -p $(dir $@)
>> +	$(CC) $(CFLAGS) -c -o $@ $<
>> +
>>  -include */.*.d */*/.*.d
>>
>>  all: $(shell git -C $(SRCDIR) rev-parse --verify --short=8 HEAD >build-head 2>/dev/null)
>>


--
Alex Bennée
